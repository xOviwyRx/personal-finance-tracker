class BudgetAlertMailer < ApplicationMailer
  def limit_alert(budget)
    @budget = budget
    @category = budget.category
    @limit = budget.monthly_limit

    mail(to: budget.user.email, subject: subject_for(budget.alerted_status))
  end

  private

  def subject_for(status)
    case status
    when 'approaching' then "You're approaching your #{@category.name} budget"
    when 'exceeded' then "You've reached your #{@category.name} budget"
    else raise ArgumentError, "unexpected alerted_status: #{status.inspect}"
    end
  end
end
