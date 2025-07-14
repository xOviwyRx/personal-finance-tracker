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

  describe "GET /api/v1/budgets" do
    it 'returns 401 when not authenticated' do
      get '/api/v1/budgets'
      expect(response).to have_http_status(:unauthorized)
    end

    context 'when authenticated' do
      before do
        post '/api/v1/users/sign_in', params: {
          user: { email: 'test@example.com', password: 'password' }
        }, as: :json
      end

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

  describe "POST /api/v1/budgets" do
    it 'returns 401 when not authenticated' do
      post '/api/v1/budgets', params: {
        budget: {
          category_id: category.id,
          monthly_limit: '3000.0',
          month: '2023-03-01'
        }
      }
      expect(response).to have_http_status(:unauthorized)
    end

    context 'when authenticated' do
      before do
        post '/api/v1/users/sign_in', params: {
          user: { email: 'test@example.com', password: 'password' }
        }, as: :json
      end

      it 'returns status code 201 and created budget' do
        post '/api/v1/budgets', params: {
          budget: {
            category_id: category.id,
            monthly_limit: '3000.0',
            month: '2023-01-01'
          }
        }
        expect(response).to  have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['monthly_limit']).to eq('3000.0')
        expect(json_response['month']).to eq('2023-01-01')
        expect(json_response).to have_key('id')
        expect(json_response).to have_key('created_at')
        expect(json_response['category_id']).to eq(category.id)
      end

      it 'returns status code 422 when category is missing' do
        post '/api/v1/budgets', params: {
          budget: {
            monthly_limit: '3000.0',
            month: '2023-01-01'
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Category must exist")
      end
    end
  end
end
