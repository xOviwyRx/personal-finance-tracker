class Api::V1::BudgetsController < ApplicationController
  def index
    render json: { message: "Budgets API endpoint" }
  end

  def create
    render json: { message: "Creates budget endpoint" }
  end
end
