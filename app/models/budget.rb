class Budget < ApplicationRecord
  belongs_to :category
  belongs_to :user

  before_validation :normalize_month

  validates :monthly_limit, presence: true
  validates :month, presence: true
  validates :user_id, uniqueness: { scope: [:category_id, :month],
                                    message: "Budget already exists for this category and month" }

  def self.ransackable_attributes(auth_object = nil)
    %w[category_id month]
  end

  private

  def normalize_month
    self.month = month.beginning_of_month if month
  end
end
