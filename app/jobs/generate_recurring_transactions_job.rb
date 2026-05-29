class GenerateRecurringTransactionsJob < ApplicationJob
  queue_as :default

  def perform
    RecurringTransaction.due.find_each { |rule| generate(rule) }
  end

  private

  def generate(rule)
    if rule.next_run_on >= Date.current.beginning_of_month
      rule.transactions.create!(
        user: rule.user,
        category: rule.category,
        title: rule.title,
        amount: rule.amount,
        transaction_type: rule.transaction_type,
        date: rule.next_run_on
      )
    end
    rule.update!(next_run_on: rule.next_future_run)
  rescue ActiveRecord::RecordNotUnique
    rule.update!(next_run_on: rule.next_future_run)
  end
end
