class Api::V1::CategoriesController < ApplicationController
  def index
    render json: { message: "Categories API endpoint" }
  end

  def create
    render json: { message: "Create category endpoint" }
  end
end
