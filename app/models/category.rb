class Category < ApplicationRecord
    belongs_to :user
    has_many :transactions

    validates :name, presence: true
    validates :name, uniqueness: { scope: :user_id }

    def self.ransackable_attributes(auth_object = nil)
        %w[name created_at updated_at]
    end
end
