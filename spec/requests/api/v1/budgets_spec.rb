require 'rails_helper'

RSpec.describe "Api::V1::Budgets", type: :request do
  let(:user) { create(:user) }
  let(:category) { create(:category, user: user) }
  let(:headers) { auth_headers_for(user) }

  describe "GET /api/v1/budgets" do
    it 'returns 401 without auth' do
      get '/api/v1/budgets'
      expect(response).to have_http_status(:unauthorized)
    end

    context 'with budgets across months' do
      let!(:january_budget) { create(:budget, user: user, category: category, month: '2023-01-01') }
      let!(:february_budget) { create(:budget, user: user, category: category, month: '2023-02-01') }

      it "returns them all" do
        get '/api/v1/budgets', headers: headers
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body.length).to eq(2)
      end

      it 'filters by month' do
        get '/api/v1/budgets?q[month_eq]=2023-01-01', headers: headers
        expect(response.parsed_body.length).to eq(1)
      end
    end

    it 'filters by category' do
      other_category = create(:category, user: user, name: 'Books')
      create(:budget, user: user, category: category)
      create(:budget, user: user, category: other_category)

      get "/api/v1/budgets?q[category_id_eq]=#{category.id}", headers: headers
      expect(response.parsed_body.length).to eq(1)
    end

    it "does not return other users' budgets" do
      other_user = create(:user)
      create(:budget, user: other_user)

      get '/api/v1/budgets', headers: headers
      expect(response.parsed_body).to be_empty
    end
  end

  describe "POST /api/v1/budgets" do
    let(:valid_params) { { budget: { category_id: category.id, monthly_limit: 3000, month: '2023-03-01' } } }

    it 'returns 401 without auth' do
      post '/api/v1/budgets', params: valid_params
      expect(response).to have_http_status(:unauthorized)
    end

    it 'creates a budget' do
      expect {
        post '/api/v1/budgets', params: valid_params, headers: headers
      }.to change(Budget, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it 'returns 422 when category is missing' do
      post '/api/v1/budgets', params: { budget: { monthly_limit: 3000, month: '2023-03-01' } }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PUT /api/v1/budgets/:id" do
    let!(:budget) { create(:budget, user: user, category: category) }

    it 'returns 401 without auth' do
      put "/api/v1/budgets/#{budget.id}", params: { budget: { monthly_limit: 4000 } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'updates the budget' do
      put "/api/v1/budgets/#{budget.id}", params: { budget: { monthly_limit: 4000 } }, headers: headers

      expect(response).to have_http_status(:ok)
      expect(budget.reload.monthly_limit).to eq(4000)
    end
  end

  describe 'DELETE /api/v1/budgets/:id' do
    let!(:budget) { create(:budget, user: user, category: category) }

    it 'returns 401 without auth' do
      delete "/api/v1/budgets/#{budget.id}"
      expect(response).to have_http_status(:unauthorized)
    end

    it 'deletes the budget' do
      expect {
        delete "/api/v1/budgets/#{budget.id}", headers: headers
      }.to change(Budget, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
