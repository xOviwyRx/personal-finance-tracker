require 'swagger_helper'

RSpec.describe 'Transactions API', type: :request do
  let(:user) { create(:user) }
  let(:Authorization) { "Bearer #{JwtService.encode(user)}" }
  let(:category) { create(:category, user: user) }

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

        before { create(:transaction, user: user, category: category) }

        run_test!
      end

      response(401, 'unauthorized') do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }

        let(:Authorization) { nil }
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

        let(:transaction) { { transaction: attributes_for(:transaction).merge(category_id: category.id) } }
        run_test!
      end

      response(401, 'unauthorized') do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }

        let(:transaction) { { transaction: { amount: '12.5', category_id: category.id, transaction_type: 'expense', title: 'Lunch' } } }
        let(:Authorization) { nil }
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

        let(:transaction) { { transaction: { amount: '-5', category_id: category.id, transaction_type: 'expense', title: 'Bad' } } }
        run_test!
      end
    end
  end

  path '/transactions/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Transaction ID'

    get('show transaction') do
      tags 'Transactions'
      produces 'application/json'

      let(:existing_transaction) { create(:transaction, user: user, category: category) }

      response(200, 'successful') do
        schema type: :object,
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

        let(:id) { existing_transaction.id }
        run_test!
      end

      response(401, 'unauthorized') do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }

        let(:id) { existing_transaction.id }
        let(:Authorization) { nil }
        run_test!
      end

      response(404, 'not found') do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }

        let(:id) { 0 }
        run_test!
      end
    end

    put('update transaction') do
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
        }
      }

      let(:existing_transaction) { create(:transaction, user: user, category: category) }

      response(200, 'successful') do
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

        let(:id) { existing_transaction.id }
        let(:transaction) { { transaction: { title: 'Updated title' } } }
        run_test!
      end

      response(401, 'unauthorized') do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }

        let(:id) { existing_transaction.id }
        let(:transaction) { { transaction: { title: 'Updated title' } } }
        let(:Authorization) { nil }
        run_test!
      end

      response(404, 'not found') do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }

        let(:id) { 0 }
        let(:transaction) { { transaction: { title: 'Updated title' } } }
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

        let(:id) { existing_transaction.id }
        let(:transaction) { { transaction: { amount: '-5' } } }
        run_test!
      end
    end

    delete('delete transaction') do
      tags 'Transactions'
      produces 'application/json'

      let(:existing_transaction) { create(:transaction, user: user, category: category) }

      response(204, 'no content') do
        let(:id) { existing_transaction.id }
        run_test!
      end

      response(401, 'unauthorized') do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }

        let(:id) { existing_transaction.id }
        let(:Authorization) { nil }
        run_test!
      end

      response(404, 'not found') do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }

        let(:id) { 0 }
        run_test!
      end
    end
  end
end
