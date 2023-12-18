# frozen_string_literal: true

RSpec.describe Invoice do
  describe '#reccuringable?' do
    subject(:reccuringable?) { invoice.recurringable? }

    context 'when invoice has a recurring profile' do
      let(:invoice) { create(:invoice, :recurringable) }

      it { is_expected.to be_truthy }
    end

    context 'when invoice is not recurring' do
      let(:invoice) { create(:invoice) }

      it { is_expected.to be_falsey }
    end
  end
end
