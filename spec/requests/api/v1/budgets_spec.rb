require 'rails_helper'

RSpec.describe "Api::V1::Budgets", type: :request do
  let!(:user) { create(:user) }
  let!(:category) { create(:category, user: user) }
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
      let(:headers) { auth_headers_for(user) }

      it 'returns status code 200 and budgets' do
        get '/api/v1/budgets', headers: headers
        expect(response).to have_http_status(:ok)
      end

      it 'returns all budgets without filter' do
        get '/api/v1/budgets', headers: headers

        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(2)
      end

      it 'filters budgets by month' do
        get '/api/v1/budgets?q[month_eq]=2023-01-01', headers: headers

        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(1)
        expect(json_response.first['month']).to eq('2023-01-01')
      end

      it 'filters budgets by category' do
        other_category = Category.create!(name: 'Books', user: user)
        Budget.create!(
          user: user,
          monthly_limit: '100',
          category: other_category,
          month: '2023-02-01'
        )
        get "/api/v1/budgets?q[category_id_eq]=#{category.id}", headers: headers
        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(2)
        expect(json_response.first['category_id']).to eq(category.id)
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
      let(:headers) { auth_headers_for(user) }

      it 'returns status code 201 and created budget' do
        post '/api/v1/budgets', params: {
          budget: {
            category_id: category.id,
            monthly_limit: '3000.0',
            month: '2023-01-01'
          }
        }, headers: headers
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
        }, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Category must exist")
      end
    end
  end

  describe "PUT /api/v1/budgets/:id" do
    it 'returns 401 when not authenticated' do
      put "/api/v1/budgets/#{budget1.id}", params: {
        budget: {
          category_id: category.id,
          monthly_limit: '3000.0',
          month: '2023-04-01'
        }
      }
      expect(response).to have_http_status(:unauthorized)
    end

    context 'when authenticated' do
      let(:headers) { auth_headers_for(user) }

      it 'returns status code 200 and updated budget' do
        put "/api/v1/budgets/#{budget1.id}", params: {
          budget: {
            category_id: category.id,
            monthly_limit: '4000.0',
            month: '2023-01-01'
          }
        }, headers: headers
        expect(response).to  have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['monthly_limit']).to eq('4000.0')
        expect(json_response['month']).to eq('2023-01-01')
        expect(json_response).to have_key('id')
        expect(Time.parse(json_response['updated_at'])).to be > Time.parse(json_response['created_at'])
        expect(json_response['category_id']).to eq(category.id)
      end
    end
  end

  describe 'DELETE /api/v1/budgets/:id' do
    it 'returns 401 when not authenticated' do
      delete "/api/v1/budgets/#{budget1.id}"
      expect(response).to have_http_status(:unauthorized)
    end

    context 'when authenticated' do
      let(:headers) { auth_headers_for(user) }

      it 'returns status code 204' do
        delete "/api/v1/budgets/#{budget1.id}", headers: headers
        expect(response).to  have_http_status(:no_content)
        expect(Budget.find_by(id: budget1.id)).to be_nil
      end
    end
  end
end
