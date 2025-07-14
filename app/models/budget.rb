class Budget < ApplicationRecord
  belongs_to :category
  belongs_to :user
  validates :monthly_limit, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[category_id month]
  end
end
