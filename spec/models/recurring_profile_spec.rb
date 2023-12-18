# frozen_string_literal: true

RSpec.describe RecurringProfile do
  describe '#end_options' do
    subject(:end_options) { recurring_profile.end_options }

    context 'ends_on is present' do
      let(:recurring_profile) { create(:recurring_profile, :with_end_date) }

      it { is_expected.to eq('after_date') }
    end

    context 'ends_after_count is present' do
      let(:recurring_profile) { create(:recurring_profile, :with_end_count) }

      it { is_expected.to eq('after_count') }
    end

    context 'ends_on and ends_after_count are not present' do
      let(:recurring_profile) { create(:recurring_profile) }

      it { is_expected.to eq('never') }
    end
  end

  describe '#should_build_next_one?' do
    subject(:should_build_next_one?) { recurring_profile.should_build_next_one? }

    context 'when end_options is never' do
      let(:recurring_profile) { create(:recurring_profile) }

      it { is_expected.to be_truthy }
    end

    context 'when end_options is after_count' do
      let(:recurring_profile) { create(:recurring_profile, :with_end_count) }

      it { is_expected.to be_truthy }

      context 'when ends_after_count is 0' do
        before { recurring_profile.update(ends_after_count: 0) }

        it { is_expected.to be_falsey }
      end
    end

    context 'when end_options is after_date' do
      let(:recurring_profile) { create(:recurring_profile, :with_end_date) }

      context 'when ends_on is future date' do
        before { recurring_profile.update(ends_on: Time.zone.tomorrow) }

        it { is_expected.to be_truthy }
      end

      context 'when ends_on is past date' do
        before { recurring_profile.update(ends_on: Time.zone.yesterday) }

        it { is_expected.to be_falsey }
      end
    end
  end

  describe '#build_draft_invoice' do
    subject(:build_draft) { recurring_profile.build_draft_invoice(invoice) }

    let(:recurring_profile) { create(:recurring_profile, :weekly, :with_end_date) }
    let(:invoice) { create(:invoice, :with_one_line, recurring_profile:) }
    let(:draft) { Invoice.drafts.last }

    it 'creates a new draft invoice' do
      expect { build_draft }.to change { Invoice.drafts.count }.by(1)
    end

    it 'sets nil number for draft invoice' do
      build_draft

      expect(draft.number).to be_nil
    end

    it 'sets issued_on to next date correctly' do
      build_draft

      expect(draft.issued_on).to eq(invoice.issued_on + 1.week)
    end

    it 'sets due_on to next date correctly' do
      build_draft

      expect(draft.due_on).to eq(invoice.due_on + 1.week)
    end
  end
end
