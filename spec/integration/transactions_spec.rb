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
                   amount: { type: :string },
                   title: { type: :string },
                   date: { type: :string, format: :date },
                   transaction_type: { type: :string },
                   category_id: { type: :integer },
                   created_at: { type: :string, format: :datetime },
                   updated_at: { type: :string, format: :datetime },
                   user_id: { type: :integer }
                 }
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

    post('create transaction') do
      tags 'Transactions'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :transaction, in: :body, schema: {
        type: :object,
        properties: {
          amount: { type: :string },
          category_id: { type: :integer },
          transaction_type: { type: :string },
          title: { type: :string }
        },
        required: %w[amount category_id transaction_type title]
      }

      response(201, 'transaction created') do
        schema type: :object,
               properties: {
                 transaction: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     title: { type: :string },
                     amount: { type: :string },
                     transaction_type: { type: :string },
                     category_id: { type: :integer },
                     created_at: { type: :string, format: :datetime },
                     updated_at: { type: :string, format: :datetime },
                     user_id: { type: :integer }
                   }
                 },
                 warnings: {
                   type: :array,
                   items: { type: :string }
                 }
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

      response(422, 'unprocessable entity') do
        schema type: :object,
               properties: {
                 errors: {
                   type: :array,
                   items: { type: :string }
                 }
               }
        run_test!
      end
    end
  end
end
