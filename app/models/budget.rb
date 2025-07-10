class Budget < ApplicationRecord
  belongs_to :category
  validates :monthly_limit, presence: true
end
