class Api::V1::RecurringTransactionsController < ApplicationController
  load_and_authorize_resource

  def index
    @recurring_transactions = @recurring_transactions.order(:next_run_on)
    render json: @recurring_transactions
  end

  def show
    render json: @recurring_transaction
  end

  def create
    if @recurring_transaction.save
      render json: @recurring_transaction, status: :created
    else
      render json: { errors: @recurring_transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @recurring_transaction.update(recurring_transaction_params)
      render json: @recurring_transaction
    else
      render json: { errors: @recurring_transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @recurring_transaction.destroy
    head :no_content
  end

  private

  def recurring_transaction_params
    params.require(:recurring_transaction).permit(:title, :amount, :transaction_type, :category_id, :start_on, :active)
  end
end
