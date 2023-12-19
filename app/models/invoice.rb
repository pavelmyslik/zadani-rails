# frozen_string_literal: true

class Invoice < ApplicationRecord
  attribute :issued_on,    :date, default: -> { Time.zone.today }
  attribute :due_on,       :date, default: -> { Time.zone.today }
  attribute :tax_point_on, :date, default: -> { Time.zone.today }

  has_many :lines, class_name: 'InvoiceLine',
                   dependent: :destroy, inverse_of: :invoice
  has_one :seller, dependent: :destroy, inverse_of: :invoice
  has_one :buyer,  dependent: :destroy, inverse_of: :invoice

  belongs_to :subscription, optional: true

  accepts_nested_attributes_for :seller
  accepts_nested_attributes_for :buyer
  accepts_nested_attributes_for :lines, allow_destroy: true

  validates :number, :issued_on, presence: true

  before_save :calculate_total
  before_save :set_dates_for_draft, if: -> { recurringable? && draft? }

  scope :drafts, -> { where(number: nil) }
  scope :existing, -> { where.not(number: nil) }

  include Recurringable

  class << self
    def increment_number(number)
      digits = number.scan(/\d+$/).first || ''
      number.sub(/\d+$/, '') + digits.next
    end
  end

  def set_dates_for_draft
    case recurring_profile.frequency
    when 'weekly'
      self.issued_on += 1.week
      self.due_on    += 1.week
    when 'monthly'
      self.issued_on += 1.month
      self.due_on    += 1.month
    when 'quarterly'
      self.issued_on += 3.months
      self.due_on    += 3.months
    when 'halfyearly'
      self.issued_on += 6.months
      self.due_on    += 6.months
    when 'yearly'
      self.issued_on += 1.year
      self.due_on    += 1.year
    end
  end

  def creatable?
    return false unless draft?

    issued_on == Time.zone.today
  end

  private

  def exact_total
    lines.map(&:total).sum
  end

  def calculate_total
    self.total = exact_total
  end

  def draft?
    number.nil?
  end
end
