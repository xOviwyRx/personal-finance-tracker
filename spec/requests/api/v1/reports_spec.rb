require 'rails_helper'

RSpec.describe "Api::V1::Reports", type: :request do
  let(:user) { create(:user) }
  let(:headers) { auth_headers_for(user) }
  let(:category) { create(:category, user: user) }

  describe "GET /api/v1/reports/monthly" do
    it 'returns 401 without auth' do
      get '/api/v1/reports/monthly'
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 400 for invalid month format' do
      get '/api/v1/reports/monthly?month=not-a-date', headers: headers
      expect(response).to have_http_status(:bad_request)
    end

    it 'defaults to current month when no month param' do
      get '/api/v1/reports/monthly', headers: headers
      expect(response.parsed_body['month']).to eq(Date.current.strftime('%Y-%m'))
    end

    context 'with transactions in the month' do
      before do
        create(:transaction, :income,  user: user, category: category, amount: 3000, date: '2026-04-01')
        create(:transaction, :expense, user: user, category: category, amount: 150, date: '2026-04-15')
      end

      it 'returns total_income' do
        get '/api/v1/reports/monthly?month=2026-04', headers: headers
        expect(response.parsed_body['total_income'].to_f).to eq(3000)
      end

      it 'returns total_expenses' do
        get '/api/v1/reports/monthly?month=2026-04', headers: headers
        expect(response.parsed_body['total_expenses'].to_f).to eq(150)
      end

      it 'returns net' do
        get '/api/v1/reports/monthly?month=2026-04', headers: headers
        expect(response.parsed_body['net'].to_f).to eq(2850)
      end
    end
  end
end
