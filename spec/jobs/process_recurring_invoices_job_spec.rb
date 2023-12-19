# frozen_string_literal: true

RSpec.describe ProcessRecurringInvoicesJob do
  describe '#perform' do
    subject(:perform) { described_class.perform_now }

    let(:invoice) do
      draft = build(:invoice, :draft)
      draft.save(validate: false)
      draft
    end

    before { allow(Invoice).to receive(:drafts).and_return([invoice]) }

    it 'builds invoice' do
      expect(invoice.recurring_profile).to receive(:build_invoice).with(invoice)
      perform
    end
  end
end
