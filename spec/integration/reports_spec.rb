require 'swagger_helper'

RSpec.describe 'Reports API', type: :request do
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
                 net: { type: :string, example: '550.0' }
               }
        run_test!
      end

      response(400, 'bad request') do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Invalid month format. Use YYYY-MM.' }
               }
        run_test!
      end

      response(401, 'unauthorized') do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }
        run_test!
      end
    end
  end
end
