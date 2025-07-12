class Api::V1::BudgetsController < ApplicationController
  before_action :set_budget, only: [:update]
  def index
    budgets = current_user.budgets.includes(:category)
    render json: budgets.as_json(include: {category: { only: [:id, :name] } })
  end

  def create
    budget = current_user.budgets.build(budget_params)
    if budget.save
      render json: budget, status: :created
    else
      render json: { errors: budget.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @budget.update(budget_params)
      render json: @budget
    else
      render json: { errors: @budget.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def set_budget
    @budget = current_user.budgets.find(params[:id])
  end

  def budget_params
    params.require(:budget).permit(:monthly_limit, :category_id, :month)
  end
end
