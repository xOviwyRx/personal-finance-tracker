require 'rails_helper'

RSpec.describe "Api::V1::RecurringTransactions", type: :request do
  let(:user) { create(:user) }
  let(:category) { create(:category, user: user) }
  let(:headers) { auth_headers_for(user) }

  describe "GET /api/v1/recurring_transactions" do
    it 'returns 401 without auth' do
      get '/api/v1/recurring_transactions'
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns only the current user's rules" do
      create(:recurring_transaction, user: user, category: category)
      create(:recurring_transaction, user: create(:user))

      get '/api/v1/recurring_transactions', headers: headers

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.length).to eq(1)
    end
  end

  describe "POST /api/v1/recurring_transactions" do
    let(:params) { { recurring_transaction: attributes_for(:recurring_transaction, category_id: category.id) } }

    it 'returns 401 without auth' do
      post '/api/v1/recurring_transactions', params: params
      expect(response).to have_http_status(:unauthorized)
    end

    it 'creates a rule' do
      expect do
        post '/api/v1/recurring_transactions', params: params, headers: headers
      end.to change(RecurringTransaction, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe "PUT /api/v1/recurring_transactions/:id" do
    let!(:rule) { create(:recurring_transaction, user: user, category: category) }

    it 'returns 401 without auth' do
      put "/api/v1/recurring_transactions/#{rule.id}", params: { recurring_transaction: { active: false } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'pauses the rule' do
      put "/api/v1/recurring_transactions/#{rule.id}",
          params: { recurring_transaction: { active: false } }, headers: headers

      expect(response).to have_http_status(:ok)
      expect(rule.reload.active).to be(false)
    end

    it "hides another user's rule behind a 404" do
      other_rule = create(:recurring_transaction, user: create(:user))

      put "/api/v1/recurring_transactions/#{other_rule.id}",
          params: { recurring_transaction: { active: false } }, headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /api/v1/recurring_transactions/:id" do
    let!(:rule) { create(:recurring_transaction, user: user, category: category) }

    it 'returns 401 without auth' do
      delete "/api/v1/recurring_transactions/#{rule.id}"
      expect(response).to have_http_status(:unauthorized)
    end

    it 'deletes the rule' do
      expect do
        delete "/api/v1/recurring_transactions/#{rule.id}", headers: headers
      end.to change(RecurringTransaction, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
