class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :amount, presence: true
  validates :transaction_type, presence: true, inclusion: { in: %w[income expense] }
  validates :title, presence: true

  before_validation :set_default_date, on: :create

  private

  def set_default_date
    self.date ||= Date.current
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[title amount date transaction_type]
  end
end