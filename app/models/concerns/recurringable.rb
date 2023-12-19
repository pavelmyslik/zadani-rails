module Recurringable
  extend ActiveSupport::Concern
  included do
    belongs_to :recurring_profile, optional: true

    accepts_nested_attributes_for :recurring_profile, allow_destroy: true

    after_destroy :destroy_recurring_profile
    after_save  :build_next_recurring_draft_if_necessary
  end

  def recurringable?
    recurring_profile.present?
  end

  private

  def destroy_recurring_profile
    recurring_profile&.destroy
  end

  def build_next_recurring_draft_if_necessary
    return if draft?
    return unless recurringable?
    return unless recurring_profile.should_build_next_one?

    recurring_profile.build_draft_invoice(self)
  end
end
