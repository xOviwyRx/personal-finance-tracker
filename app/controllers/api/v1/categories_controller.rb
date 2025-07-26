class Api::V1::CategoriesController < ApplicationController
  load_and_authorize_resource
  def index
    if params[:q].present?
      @q = @categories.ransack(params[:q])
      @categories = @q.result
    end

    render json: @categories
  end

  def create
    if @category.save
      render json: @category, status: :created
    else
      render json: { errors:@category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      render json: @category
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy!
    head :no_content
  rescue ActiveRecord::InvalidForeignKey
    render json: {
      error: "Category cannot be deleted because it has associated transactions"
    }, status: :unprocessable_entity
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
