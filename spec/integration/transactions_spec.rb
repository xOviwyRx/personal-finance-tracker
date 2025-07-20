require 'swagger_helper'

RSpec.describe 'Transactions API', type: :request do
  path '/transactions' do
    get('list transactions') do
      tags 'Transactions'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   amount: { type: :number },
                   title: { type: :string },
                   date: { type: :date },
                   transaction_type: { type: :string },
                   category_id: { type: :integer },
                   created_at: { type: :datetime, format: :iso8601 },
                   updated_at: { type: :datetime, format: :iso8601 },
                   user_id: { type: :integer },
                 }
               }

        run_test!
      end
    end

    post('create transaction') do
      tags 'Transactions'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :transaction, in: :body, schema: {
        type: :object,
        properties: {
          amount: { type: :number },
          category_id: { type: :integer },
          transaction_type: { type: :string },
          title: { type: :string },
        },
        required: %w[amount category_id transaction_type title]
      }

      response(201, 'transaction created') do
        run_test!
      end
    end
  end
end