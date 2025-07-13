require 'rails_helper'

RSpec.describe "Api::V1::Categories", type: :request do
  let!(:user) { User.create!(email: 'test@example.com', password: 'password') }
  before do
    post '/api/v1/users/sign_in', params: {
      user: { email: 'test@example.com', password: 'password' }
    }, as: :json
  end

  describe "GET /api/v1/categories" do
    let!(:category1) { Category.create!(name: 'Electronics', user: user) }
    let!(:category2) { Category.create!(name: 'Books', user: user) }

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
      post '/api/v1/categories', params: { category: { name: 'Electronics' } }, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns created category' do
      post '/api/v1/categories', params: { category: { name: 'Electronics' } }, as: :json
      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq('Electronics')
    end

    it 'does not allow creating duplicate category with same user' do
      Category.create!(name: 'Electronics', user: user)
      post '/api/v1/categories', params: { category: { name: 'Electronics' } }, as: :json
      expect(response).to have_http_status(:unprocessable_content)
      json_response = JSON.parse(response.body)
      Rails.logger.debug(json_response['errors'])
      expect(json_response['errors']).to include("Name has already been taken")
    end
  end
end
