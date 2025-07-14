require 'rails_helper'

RSpec.describe "Api::V1::Transactions", type: :request do
  let!(:user) { User.create!(email: 'test@example.com', password: 'password') }
  let!(:category) { Category.create!(name: 'Electronics', user: user) }
  let!(:transaction1) { Transaction.create!(
    title: 'Laptop',
    user: user,
    category: category,
    amount: 1500,
    transaction_type: 'expense',
  ) }
  let!(:transaction2) { Transaction.create!(
    title: 'PC',
    user: user,
    category: category,
    amount: 1500,
    transaction_type: 'expense',
  ) }

  describe "GET /api/v1/transactions" do
    it 'returns 401 when not authenticated' do
      get '/api/v1/transactions'
      expect(response).to have_http_status(:unauthorized)
    end

    context 'when authenticated' do
      before do
        post '/api/v1/users/sign_in', params: {
          user: { email: 'test@example.com', password: 'password' }
        }, as: :json
      end

      it 'returns status code 200' do
        get '/api/v1/transactions'
        expect(response).to have_http_status(:ok)
      end

      it 'returns transactions' do
        get '/api/v1/transactions'

        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(2)
      end
    end
  end

  describe 'POST /api/v1/transactions' do
    it 'returns 401 when not authenticated' do
      post '/api/v1/transactions', params: {
        transaction: {
          amount: 20.0,
          category_id: category.id,
          title: "Keyboard",
          transaction_type: "expense"
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

      it 'returns status code 201' do
        post '/api/v1/transactions', params: {
          transaction: {
            amount: 20.0,
            category_id: category.id,
            title: "Keyboard",
            transaction_type: "expense"
          }
        }
        expect(response).to have_http_status(:created)
      end

      it 'returns created transaction' do
        post '/api/v1/transactions', params: {
          transaction: {
            amount: 20.0,
            category_id: category.id,
            title: "Keyboard",
            transaction_type: "expense"
          }
        }
        json_response = JSON.parse(response.body)
        expect(json_response['title']).to eq('Keyboard')
        expect(json_response['amount']).to eq('20.0')
        expect(json_response['transaction_type']).to eq('expense')
        expect(json_response['category_id']).to eq(category.id)
      end
    end
  end
end
