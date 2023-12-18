# frozen_string_literal: true

FactoryBot.define do
  factory :invoice_line, class: 'InvoiceLine' do
    invoice
    description { 'Programming' }
    quantity { FFaker::Random.rand(120..160) }
    price { FFaker::Random.rand(150..300) }
  end
end
