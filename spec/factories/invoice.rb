# frozen_string_literal: true

FactoryBot.define do
  factory :invoice, class: 'Invoice' do
    number { '1' }
    issued_on { FFaker::Time.date }
    due_on { FFaker::Time.date }

    trait :with_one_line do
      after(:create) do |invoice|
        create(:invoice_line, invoice:)
      end
    end

    trait :with_lines do
      after(:create) do |invoice|
        create_list(:invoice_line, 3, invoice:)
      end
    end

    trait :recurringable_with_date do
      after(:create) do |invoice|
        create(:recurring_profile, :with_end_date, invoices: [invoice])
      end
    end

    trait :recurringable_with_count do
      after(:create) do |invoice|
        create(:recurring_profile, :with_end_count, invoices: [invoice])
      end
    end

    trait :recurringable do
      after(:create) do |invoice|
        create(:recurring_profile, invoices: [invoice])
      end
    end

    trait :draft do
      number { nil }
    end
  end
end
