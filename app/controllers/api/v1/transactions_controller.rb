class Api::V1::TransactionsController < ApplicationController
  load_and_authorize_resource
  def index
    render json: @transactions
  end

  def create
    if @transaction.save
      render json: @transaction, status: :created
    else
      render json: { errors:@transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:amount, :category_id, :title, :transaction_type)
  end
end
