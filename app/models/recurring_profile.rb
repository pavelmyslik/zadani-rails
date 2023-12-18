# frozen_string_literal: true

class RecurringProfile < ActiveRecord::Base
  has_many :invoices, :foreign_key => 'recurring_profile_id'

  attr_accessor :end_options

  validates     :frequency, presence: true
  validates    :frequency,   inclusion: { in: %w[weekly monthly quaterly halfyearly yearly] }
  validates    :end_options, inclusion: { in: %w[never after_count after_date] }
  validates :ends_after_count, numericality: { greater_than: 0, allow_blank: true }

  before_save  :handle_end_options

  after_update :update_recurring_invoices

  def should_build_next_one?
    return false if end_options == 'never'

  end

  def build_invoice(invoice)
    #musím snížit počet zbývajících opakování
  end

  protected

  def update_recurring_invoices
  end

  def handle_end_options
    self.end_options = if ends_on.present?
                         'after_date'
                       elsif ends_after_count.present?
                         'after_count'
                       else
                         'never'
                       end
  end
end
