class Api::V1::TransactionsController < ApplicationController
  load_and_authorize_resource
  def index
    if params[:q].present?
      @q = @transactions.ransack(params[:q])
      @transactions = @q.result
    end

    @transactions = @transactions.order(created_at: :desc)
    render json: @transactions
  end

  def show
    render json: @transaction
  end

  def create
    if @transaction.save
      warnings = BudgetWarningService.new(@transaction).generate_warnings
      render json: {
        transaction: @transaction,
        warnings: warnings
      }, status: :created
    else
      render json: { errors: @transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @transaction.update(transaction_params)
      warnings = BudgetWarningService.new(@transaction).generate_warnings
      render json: {
        transaction: @transaction,
        warnings: warnings
      }
    else
      render json: { errors: @transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction.destroy
    head :no_content
  end

  private

  def transaction_params
    params.require(:transaction).permit(:amount, :category_id, :title, :transaction_type)
  end
end
