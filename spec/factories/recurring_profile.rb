# frozen_string_literal: true

FactoryBot.define do
  factory :recurring_profile, class: 'RecurringProfile' do
    frequency { %w[weekly monthly quaterly halfyearly yearly].sample }
    end_options { 'never' }

    trait :with_end_date do
      ends_on { FFaker::Time.between(Time.zone.today, 1.year.from_now).to_date }
      end_options { 'after_date' }
    end

    trait :with_end_count do
      ends_after_count { rand(1..10) }
      end_options { 'after_count' }
    end

    trait :with_invoices do
      after(:create) do |recurring_profile|
        create_list(:invoice, 3, :with_one_line, recurring_profile:)
      end
    end
  end
end
