class Api::V1::TransactionsController < ApplicationController
  def index
    render json: current_user.transactions
  end

  def create
    render json: { message: "Create transaction endpoint" }
  end
end
