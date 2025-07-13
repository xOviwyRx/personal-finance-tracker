require 'rails_helper'

RSpec.describe "Api::V1::Categories", type: :request do
  let!(:user) { User.create!(email: 'test@example.com', password: 'password') }
  let!(:category1) { Category.create!(name: 'Electronics', user: user) }
  let!(:category2) { Category.create!(name: 'Books', user: user) }
  before do
    post '/api/v1/users/sign_in', params: {
      user: { email: 'test@example.com', password: 'password' }
    }, as: :json
  end

  describe "GET /api/v1/categories" do

    it 'returns status code 200' do
      get '/api/v1/categories'
      expect(response).to have_http_status(:success)
    end

    it 'returns categories' do
      get '/api/v1/categories'

      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(2)
      expect(json_response.first).to have_key('name')
    end

  end

  describe "POST /api/v1/categories" do
    it 'returns success status' do
      post '/api/v1/categories', params: { category: { name: 'Food' } }, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns created category' do
      post '/api/v1/categories', params: { category: { name: 'Food' } }, as: :json
      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq('Food')
    end

    it 'does not allow creating duplicate category with same user' do
      post '/api/v1/categories', params: { category: { name: 'Electronics' } }, as: :json
      expect(response).to have_http_status(:unprocessable_content)
      json_response = JSON.parse(response.body)
      Rails.logger.debug(json_response['errors'])
      expect(json_response['errors']).to include("Name has already been taken")
    end
  end

  describe "PUT /api/v1/categories/:id" do
    it 'updates the category successfully' do
      put "/api/v1/categories/#{category1.id}", params: { category: { name: 'Updated Electronics' } }, as: :json
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["name"]).to eq("Updated Electronics")
      expect(category1.reload.name).to eq("Updated Electronics")
    end
  end

  describe "DELETE /api/v1/categories/:id" do
    it 'deletes the category successfully' do
      delete "/api/v1/categories/#{category1.id}"
      expect(response).to have_http_status(:no_content)
    end
  end
end
