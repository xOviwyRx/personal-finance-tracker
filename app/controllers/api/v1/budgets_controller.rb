class Api::V1::BudgetsController < ApplicationController
  load_and_authorize_resource
  def index
    @budgets = @budgets.includes(:category)
    render json: @budgets.as_json(include: {category: { only: [:id, :name] } })
  end

  def create
    if @budget.save
      render json: @budget, status: :created
    else
      render json: { errors: @budget.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @budget.update(budget_params)
      render json: @budget
    else
      render json: { errors: @budget.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @budget.destroy
    head :no_content
  end

  private

  def budget_params
    params.require(:budget).permit(:monthly_limit, :category_id, :month)
  end
end
