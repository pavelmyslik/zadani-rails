# frozen_string_literal: true

FactoryBot.define do
  factory :recurring_profile, class: 'RecurringProfile' do
    frequency { %w[weekly monthly quaterly halfyearly yearly].sample }
    end_options { %w[never after_count after_date].sample }

    trait :with_end_date do
      ends_on { FFaker::Time.date }
    end

    trait :with_end_count do
      ends_after_count { rand(1..10) }
    end

    trait :never do
      end_options { 'never' }
    end

    trait :with_invoices do
      after(:create) do |recurring_profile|
        create_list(:invoice, 3, :with_line, :recurringable, recurring_profile:)
      end
    end
  end
end
