# frozen_string_literal: true

module Types
  class InvoiceType < Types::BaseObject
    description 'This is an invoice'

    field :id, ID, null: true
    field :number, String, null: true
    field :total, Float, null: true
    field :issued_on, GraphQL::Types::ISO8601DateTime, null: true
    field :due_on, GraphQL::Types::ISO8601DateTime, null: true
  end
end
