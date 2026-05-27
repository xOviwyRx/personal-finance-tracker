class BudgetAlertJob < ApplicationJob
  queue_as :default

  def perform(transaction_id)
    transaction = Transaction.find_by(id: transaction_id)
    return unless transaction

    service = BudgetWarningService.new(transaction)
    status = service.alert_status
    return if status == :none

    budget = service.current_budget
    return unless budget

    escalated = false
    budget.with_lock do
      if budget.alert_escalated_to?(status)
        budget.update!(alerted_status: status)
        escalated = true
      end
    end

    BudgetAlertMailer.limit_alert(budget).deliver_later if escalated
  end
end
