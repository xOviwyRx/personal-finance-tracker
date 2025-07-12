class Api::V1::CategoriesController < ApplicationController
  def index
    render json: current_user.categories
  end

  def create
    render json: { message: "Create category endpoint" }
  end
end
