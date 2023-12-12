class Subscription < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable, :recoverable

  has_many :invoices, dependent: :nullify

  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: /^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,6}+$/i, multiline: true }
end
