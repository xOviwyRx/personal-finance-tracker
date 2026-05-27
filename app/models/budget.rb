class Budget < ApplicationRecord
  belongs_to :category
  belongs_to :user

  ALERT_LEVELS = { none: 0, approaching: 1, exceeded: 2 }.freeze
  enum :alerted_status, ALERT_LEVELS, default: :none, prefix: :alert

  before_validation :normalize_month

  validates :monthly_limit, presence: true
  validates :month, presence: true
  validates :user_id, uniqueness: { scope: [:category_id, :month],
                                    message: "Budget already exists for this category and month" }

  def self.ransackable_attributes(auth_object = nil)
    %w[category_id month]
  end

  def alert_escalated_to?(status)
    ALERT_LEVELS[status.to_sym] > ALERT_LEVELS[alerted_status.to_sym]
  end

  private

  def normalize_month
    self.month = month.beginning_of_month if month
  end
end
