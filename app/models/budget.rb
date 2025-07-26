class Budget < ApplicationRecord
  belongs_to :category
  belongs_to :user
  validates :monthly_limit, presence: true
  validates :user_id, uniqueness: { scope: [:category_id, :month],
                                    message: "Budget already exists for this category and month" }

  def self.ransackable_attributes(auth_object = nil)
    %w[category_id month]
  end
end
