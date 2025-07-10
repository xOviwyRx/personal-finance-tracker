class Api::V1::TransactionsController < ApplicationController
  def index
    render json: { message: "Transactions API endpoint" }
  end

  def create
    render json: { message: "Create transaction endpoint" }
  end
end
