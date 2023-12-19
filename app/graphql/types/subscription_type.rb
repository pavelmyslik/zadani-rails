# frozen_string_literal: true

module Types
  class SubscriptionType < Types::BaseObject
    description 'This is a subscription'

    field :id, ID, null: true
    field :email, String, null: true
    field :invoices, [Types::InvoiceType], null: true
    field :drafts, [Types::InvoiceType], null: true

    def invoices
      object.invoices.existing.all
    end

    def drafts
      object.invoices.drafts.all
    end
  end
end
