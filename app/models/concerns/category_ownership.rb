module CategoryOwnership
  extend ActiveSupport::Concern

  included do
    validate :category_belongs_to_user
  end

  private

  def category_belongs_to_user
    errors.add(:category, "must belong to the same user") if category && category.user != user
  end
end
