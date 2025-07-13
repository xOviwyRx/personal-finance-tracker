class Api::V1::TransactionsController < ApplicationController
  def index
    render json: current_user.transactions
  end

  def create
    @transaction = current_user.transactions.build(transaction_params)
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
