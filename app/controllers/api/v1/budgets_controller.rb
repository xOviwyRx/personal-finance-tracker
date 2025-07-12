class Api::V1::BudgetsController < ApplicationController
  def index
    budgets = current_user.budgets.includes(:category)
    render json: budgets.as_json(include: {category: { only: [:id, :name] } })
  end

  def create
    render json: { message: "Creates budget endpoint" }
  end
end
