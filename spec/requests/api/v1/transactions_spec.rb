require 'rails_helper'

RSpec.describe "Api::V1::Transactions", type: :request do
  let!(:user) { create(:user) }
  let!(:category) { create(:category, user: user, name: 'Electronics') }
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
      let(:headers) { auth_headers_for(user) }

      it 'returns status code 200' do
        get '/api/v1/transactions', headers: headers
        expect(response).to have_http_status(:ok)
      end

      it 'returns all transactions without search' do
        get '/api/v1/transactions', headers: headers

        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(2)
      end

      it 'filters by title' do
        get '/api/v1/transactions?q[title_eq]=Laptop', headers: headers

        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(1)
        expect(json_response.first['title']).to eq('Laptop')
      end

      it 'filters by amount' do
        get '/api/v1/transactions?q[amount_gt]=1500', headers: headers
        json_response = JSON.parse(response.body)
        amounts = json_response.map { |t| t['amount'].to_f }
        expect(amounts).to all(be > 1500)
      end

      it 'filters by date' do
        get '/api/v1/transactions?q[date_gt]=2025-01-15', headers: headers
        json_response = JSON.parse(response.body)
        dates = json_response.map { |t| Date.parse(t['date']) }
        expect(dates).to all(be > Date.parse('2025-01-15'))
      end

      it 'filters by transaction_type' do
        get '/api/v1/transactions?q[transaction_type_eq]=expense', headers: headers
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
      let(:headers) { auth_headers_for(user) }

      it 'returns status code 201' do
        post '/api/v1/transactions', params: {
          transaction: {
            amount: 20.0,
            category_id: category.id,
            title: "Keyboard",
            transaction_type: "expense"
          }
        }, headers: headers
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
        }, headers: headers
        json_response = JSON.parse(response.body)
        expect(json_response['transaction']['title']).to eq('Keyboard')
        expect(json_response['transaction']['amount']).to eq('20.0')
        expect(json_response['transaction']['transaction_type']).to eq('expense')
        expect(json_response['transaction']['category_id']).to eq(category.id)
      end

      context 'budget warnings' do
        let(:budget_category) { create(:category, user: user) }
        let(:budget) { Budget.create(category: budget_category, user: user, monthly_limit: 1000, month: Date.current.beginning_of_month) }

        context 'when budget is exceeded' do
          before do
            Transaction.create!(
              title: 'Existing expense 1',
              user: user,
              category: budget_category,
              amount: 500,
              date: Date.current,
              transaction_type: 'expense'
            )
            Transaction.create!(
              title: 'Existing expense 2',
              user: user,
              category: budget_category,
              amount: 300,
              date: Date.current,
              transaction_type: 'expense'
            )
            budget
          end

          it 'warns when budget is exceeded' do
            post '/api/v1/transactions', params: {
              transaction: {
                amount: 250.0,
                category_id: budget_category.id,
                title: "Budget exceeding expense",
                transaction_type: "expense"
              }
            }, headers: headers

            expect(response).to have_http_status(:created)
            json_response = JSON.parse(response.body)

            expect(json_response['warnings']).to include("You have exceeded the budget limit for category 'Food' by 50.0.")
          end

          it 'warns when budget limit is reached' do
            post '/api/v1/transactions', params: {
              transaction: {
                amount: 200.0,
                category_id: budget_category.id,
                title: "Budget limit reached",
                transaction_type: "expense"
              }
            }, headers: headers

            expect(response).to have_http_status(:created)
            json_response = JSON.parse(response.body)

            expect(json_response['warnings']).to include("You've reached the budget limit for category 'Food'.")
          end

          it 'warns when approaching budget limit' do
            post '/api/v1/transactions', params: {
              transaction: {
                amount: 150.0,
                category_id: budget_category.id,
                title: "Almost budget limit expense",
                transaction_type: "expense"
              }
            }, headers: headers

            expect(response).to have_http_status(:created)
            json_response = JSON.parse(response.body)

            expect(json_response['warnings']).to include("You're approaching your budget limit for category 'Food'.")
          end
        end
      end
    end
  end
end
