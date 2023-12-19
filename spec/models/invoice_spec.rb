# frozen_string_literal: true

RSpec.describe Invoice do
  describe '#reccuringable?' do
    subject(:reccuringable?) { invoice.recurringable? }

    context 'when invoice has a recurring profile' do
      let(:invoice) { create(:invoice, :recurringable) }

      it { is_expected.to be_truthy }
    end

    context 'when invoice is not recurring profile' do
      let(:invoice) { create(:invoice) }

      it { is_expected.to be_falsey }
    end
  end

  context 'when invoice is destroyed' do
    let!(:invoice) { create(:invoice) }

    it 'destroys it' do
      expect { invoice.destroy }.to change { Invoice.count }.from(1).to(0)
    end

    context 'when invoice has a recurring profile' do
      let!(:invoice) { create(:invoice, :recurringable) }

      it 'destroys recurring profile' do
        expect { invoice.destroy }.to change { RecurringProfile.count }.from(1).to(0)
      end
    end
  end

  describe 'creating a new recurring draft' do
    subject(:drafts) { Invoice.drafts }

    context 'when invoice has not a recurring profile' do
      let(:invoice) { create(:invoice) }

      it 'does not create a new draft invoice' do
        expect(drafts.count).to eq(0)
      end
    end

    context 'when invoice is a draft' do
      it 'does not create a new draft invoice' do
        draft = build(:invoice, :draft)
        draft.save(validate: false)
        expect(drafts.count).to eq(1)
      end
    end

    context 'when invoice has a recurring profile' do
      let(:invoice) { build(:invoice, recurring_profile:) }

      before { invoice.save }

      context 'when recurring profile is not active' do
        let(:recurring_profile) { create(:recurring_profile, :with_end_date, ends_on: Time.zone.yesterday) }

        it 'does not create a new draft invoice' do
          expect(drafts.count).to eq(0)
        end
      end

      context 'when recurring profile is active' do
        let(:recurring_profile) { create(:recurring_profile, :with_end_date, ends_on: Time.zone.tomorrow) }

        it 'creates a new draft invoice' do
          expect(drafts.count).to eq(1)
        end

        it 'sets nil number for draft invoice' do
          expect(drafts.last.number).to be_nil
        end
      end
    end
  end
end
