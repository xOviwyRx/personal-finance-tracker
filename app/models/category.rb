class Category < ApplicationRecord
    belongs_to :user
    has_many :transactions, dependent: :restrict_with_error
    has_many :budgets, dependent: :destroy

    validates :name, presence: true
    validates :name, uniqueness: { scope: :user_id }

    def self.ransackable_attributes(auth_object = nil)
        %w[name]
    end
end
