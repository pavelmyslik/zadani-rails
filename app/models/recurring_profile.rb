# frozen_string_literal: true

class RecurringProfile < ApplicationRecord
  has_many :invoices

  attr_accessor :end_options

  validates     :frequency, presence: true
  validates    :frequency,   inclusion: { in: %w[weekly monthly quaterly halfyearly yearly] }
  validates    :end_options, inclusion: { in: %w[never after_count after_date] }
  validates :ends_after_count, numericality: { greater_than: 0, allow_blank: true }

  before_save  :handle_end_options

  after_update :update_recurring_invoices

  def should_build_next_one?
    return true if end_options == 'never'

    count_active? || date_active?
  end

  def build_invoice(invoice); end

  def build_draft_invoice(invoice)
    draft = invoice.dup
    draft.number = nil

    draft.save!(validate: false)
    reduce_remaining_count if after_count?
  end

  protected

  def update_recurring_invoices; end

  def handle_end_options
    self.end_options = if ends_on.present?
                         'after_date'
                       elsif after_count?
                         'after_count'
                       else
                         'never'
                       end
  end

  private

  def count_active?
    ends_after_count.present? && ends_after_count.positive?
  end

  def date_active?
    ends_on.present? && ends_on >= Time.zone.today
  end

  def after_count?
    end_options == 'after_count'
  end

  def reduce_remaining_count
    nullify_remaining_count if ends_after_count == 1

    update!(ends_after_count: ends_after_count - 1)
  end

  def nullify_remaining_count
    update!(ends_after_count: nil)
  end
end
