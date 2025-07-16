require 'rails_helper'

RSpec.describe "Api::V1::Transactions", type: :request do
  let!(:user) { User.create!(email: 'test@example.com', password: 'password') }
  let!(:category) { Category.create!(name: 'Electronics', user: user) }
  let!(:transaction1) { Transaction.create!(
    title: 'Laptop',
    user: user,
    category: category,
    amount: 2000,
    date: '2025-01-15',
    transaction_type: 'expense',
  ) }
  let!(:transaction2) { Transaction.create!(
    title: 'PC',
    user: user,
    category: category,
    amount: 1500,
    date: '2025-03-15',
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

      it 'returns all transactions without search' do
        get '/api/v1/transactions'

        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(2)
      end

      it 'filters by title' do
        get '/api/v1/transactions?q[title_eq]=Laptop'

        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(1)
        expect(json_response.first['title']).to eq('Laptop')
      end

      it 'filters by amount' do
        get '/api/v1/transactions?q[amount_gt]=1500'
        json_response = JSON.parse(response.body)
        amounts = json_response.map { |t| t['amount'].to_f }
        expect(amounts).to all(be > 1500)
      end

      it 'filters by date' do
        get '/api/v1/transactions?q[date_gt]=2025-01-15'
        json_response = JSON.parse(response.body)
        dates = json_response.map { |t| Date.parse(t['date']) }
        expect(dates).to all(be > Date.parse('2025-01-15'))
      end

      it 'filters by transaction_type' do
        get '/api/v1/transactions?q[transaction_type_eq]=expense'
        json_response = JSON.parse(response.body)
        transaction_types = json_response.map { |t| t['transaction_type'] }
        expect(transaction_types).to all(eq('expense'))
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
        expect(json_response['transaction']['title']).to eq('Keyboard')
        expect(json_response['transaction']['amount']).to eq('20.0')
        expect(json_response['transaction']['transaction_type']).to eq('expense')
        expect(json_response['transaction']['category_id']).to eq(category.id)
      end
    end
  end
end
