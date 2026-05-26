require 'swagger_helper'

RSpec.describe 'Reports API', type: :request do
  let(:user) { create(:user) }
  let(:Authorization) { "Bearer #{JwtService.encode(user)}" }
  let(:category) { create(:category, user: user) }

  path '/reports/monthly' do
    get('monthly spending summary') do
      tags 'Reports'
      produces 'application/json'

      parameter name: :month, in: :query, type: :string, required: false,
                description: 'Month in YYYY-MM format. Defaults to current month if omitted.',
                example: '2026-04'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 month: { type: :string, example: '2026-04' },
                 total_income: { type: :string, example: '3000.0' },
                 total_expenses: { type: :string, example: '2450.0' },
                 net: { type: :string, example: '550.0' },
                 category_breakdown: {
                   type: :object,
                   additionalProperties: { type: :string },
                   example: { 'Groceries' => '820.0', 'Rent' => '1500.0' }
                 }
               }

        let(:month) { Date.current.strftime('%Y-%m') }
        before do
          create(:transaction, :income, user: user, category: category)
          create(:transaction, user: user, category: category)
        end

        run_test!
      end

      response(400, 'bad request') do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Invalid month format. Use YYYY-MM.' }
               }

        let(:month) { 'not-a-month' }
        run_test!
      end

      response(401, 'unauthorized') do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }

        let(:month) { '2026-04' }
        let(:Authorization) { nil }
        run_test!
      end
    end
  end
end
