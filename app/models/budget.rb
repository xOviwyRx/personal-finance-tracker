class Budget < ApplicationRecord
  belongs_to :category
  belongs_to :user
  validates :monthly_limit, presence: true
end
