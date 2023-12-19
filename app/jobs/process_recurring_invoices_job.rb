# frozen_string_literal: true

class ProcessRecurringInvoicesJob < ApplicationJob
  queue_as :default

  def perform
    Invoice.drafts.each do |invoice|
      invoice.recurring_profile.build_invoice(invoice)
    end
  end
end
