class InvoiceLine < ApplicationRecord
  belongs_to :invoice, inverse_of: :lines

  default_scope { order(position: :asc, id: :asc) }

  def total
    (quantity * price).round(2)
  end
end
