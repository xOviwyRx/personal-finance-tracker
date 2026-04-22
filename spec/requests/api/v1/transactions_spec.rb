require 'rails_helper'

RSpec.describe "Api::V1::Transactions", type: :request do
  let(:user) { create(:user) }
  let(:category) { create(:category, user: user, name: 'Electronics') }
  let(:headers) { auth_headers_for(user) }

  describe "GET /api/v1/transactions" do
    it 'returns 401 without auth' do
      get '/api/v1/transactions'
      expect(response).to have_http_status(:unauthorized)
    end

    context 'with existing transactions' do
      let!(:laptop_transaction) { create(:transaction, user: user, category: category, title: 'Laptop', amount: 2000, date: '2025-01-15') }
      let!(:pc_transaction)     { create(:transaction, user: user, category: category, title: 'PC', amount: 1500, date: '2025-03-15') }

      it "returns user's transactions" do
        get '/api/v1/transactions', headers: headers
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body.length).to eq(2)
      end

      it 'filters by title' do
        get '/api/v1/transactions?q[title_eq]=Laptop', headers: headers
        expect(response.parsed_body.length).to eq(1)
      end

      it 'filters by amount' do
        get '/api/v1/transactions?q[amount_gt]=1500', headers: headers
        expect(response.parsed_body.length).to eq(1)
      end

      it 'filters by date' do
        get '/api/v1/transactions?q[date_gt]=2025-01-15', headers: headers
        expect(response.parsed_body.length).to eq(1)
      end

      it 'filters by transaction_type' do
        get '/api/v1/transactions?q[transaction_type_eq]=expense', headers: headers
        expect(response.parsed_body.length).to eq(2)
      end
    end

    it "does not return other users' transactions" do
      other_user = create(:user)
      create(:transaction, user: other_user)

      get '/api/v1/transactions', headers: headers
      expect(response.parsed_body).to be_empty
    end
  end

  describe 'POST /api/v1/transactions' do
    let(:valid_params) do
      { transaction: { amount: 20.0, category_id: category.id, title: 'Keyboard', transaction_type: 'expense' } }
    end

    it 'returns 401 without auth' do
      post '/api/v1/transactions', params: valid_params
      expect(response).to have_http_status(:unauthorized)
    end

    it 'creates a transaction' do
      expect do
        post '/api/v1/transactions', params: valid_params, headers: headers
      end.to change(Transaction, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    describe 'budget warnings' do
      let(:food_category) { create(:category, user: user, name: 'Food') }
      let!(:budget)       { create(:budget, user: user, category: food_category, monthly_limit: 1000) }

      before do
        create(:transaction, :expense, user: user, category: food_category, amount: 500, date: Date.current)
        create(:transaction, :expense, user: user, category: food_category, amount: 300, date: Date.current)
      end

      def post_expense(amount)
        post '/api/v1/transactions', params: {
          transaction: { amount: amount, category_id: food_category.id, title: 'Expense', transaction_type: 'expense' }
        }, headers: headers
      end

      it 'warns when exceeded' do
        post_expense(250)
        expect(response.parsed_body['warnings']).to include("You have exceeded the budget limit for category 'Food' by 50.0.")
      end

      it 'warns when limit is reached' do
        post_expense(200)
        expect(response.parsed_body['warnings']).to include("You've reached the budget limit for category 'Food'.")
      end

      it 'warns when approaching limit' do
        post_expense(150)
        expect(response.parsed_body['warnings']).to include("You're approaching your budget limit for category 'Food'.")
      end
    end
  end

  describe 'GET /api/v1/transactions/:id' do
    let!(:transaction) { create(:transaction, user: user, category: category) }

    it 'returns 401 without auth' do
      get "/api/v1/transactions/#{transaction.id}"
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns the transaction' do
      get "/api/v1/transactions/#{transaction.id}", headers: headers
      expect(response).to have_http_status(:ok)
    end

    it "denies access to another user's transaction" do
      other_transaction = create(:transaction)

      get "/api/v1/transactions/#{other_transaction.id}", headers: headers
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'PUT /api/v1/transactions/:id' do
    let!(:transaction) { create(:transaction, user: user, category: category, amount: 100) }

    it 'returns 401 without auth' do
      put "/api/v1/transactions/#{transaction.id}", params: { transaction: { amount: 200 } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'updates the transaction' do
      put "/api/v1/transactions/#{transaction.id}", params: { transaction: { amount: 200 } }, headers: headers

      expect(response).to have_http_status(:ok)
      expect(transaction.reload.amount).to eq(200)
    end

    it 'returns 422 for invalid transaction_type' do
      put "/api/v1/transactions/#{transaction.id}", params: { transaction: { transaction_type: 'invalid' } }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /api/v1/transactions/:id' do
    let!(:transaction) { create(:transaction, user: user, category: category) }

    it 'returns 401 without auth' do
      delete "/api/v1/transactions/#{transaction.id}"
      expect(response).to have_http_status(:unauthorized)
    end

    it 'deletes the transaction' do
      expect do
        delete "/api/v1/transactions/#{transaction.id}", headers: headers
      end.to change(Transaction, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
