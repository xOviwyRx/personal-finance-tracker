require 'rails_helper'

RSpec.describe "Api::V1::Budgets", type: :request do
  let!(:user) { User.create!(email: 'test@example.com', password: 'password') }
  let!(:category) { Category.create!(name: 'Electronics', user: user) }
  let!(:budget1) { Budget.create!(
    user: user,
    monthly_limit: '1000',
    category: category,
    month: '2023-01-01'
  ) }
  let!(:budget2) { Budget.create!(
    user: user,
    monthly_limit: '2000',
    category: category,
    month: '2023-02-01'
  ) }
  before do
    post '/api/v1/users/sign_in', params: {
      user: { email: 'test@example.com', password: 'password' }
    }, as: :json
  end

  describe "GET /api/v1/budgets" do

    it 'returns status code 200 and budgets' do
      get '/api/v1/budgets'
      expect(response).to have_http_status(:success)
    end

    it 'returns budgets' do
      get '/api/v1/budgets'

      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(2)
    end

  end
end
