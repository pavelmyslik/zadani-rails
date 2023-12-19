# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :invoice, Types::InvoiceType, null: true, description: 'Find an invoice by its ID' do
      argument :id, ID, required: true
    end

    def invoice(id:)
      Invoice.existing.find(id)
    end

    field :draft, Types::InvoiceType, null: true, description: 'Find a draft by its ID' do
      argument :id, ID, required: true
    end

    def draft(id:)
      Invoice.drafts.find(id)
    end

    field :invoices, [Types::InvoiceType], null: false, description: 'All existing invoices'

    def invoices
      Invoice.existing.all
    end

    field :drafts, [Types::InvoiceType], null: false, description: 'All existing drafts'

    def drafts
      Invoice.drafts.all
    end
  end
end
