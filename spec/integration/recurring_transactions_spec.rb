require 'swagger_helper'

RSpec.describe 'Recurring Transactions API', type: :request do
  let(:user) { create(:user) }
  let(:category) { create(:category, user: user) }
  let(:Authorization) { "Bearer #{JwtService.encode(user)}" }

  rule_schema = {
    type: :object,
    properties: {
      id: { type: :integer },
      user_id: { type: :integer },
      category_id: { type: :integer },
      title: { type: :string },
      amount: { type: :string },
      transaction_type: { type: :string },
      start_on: { type: :string, format: :date },
      next_run_on: { type: :string, format: :date },
      active: { type: :boolean },
      created_at: { type: :string, format: :datetime },
      updated_at: { type: :string, format: :datetime }
    }
  }

  path '/recurring_transactions' do
    get('list recurring transactions') do
      tags 'Recurring Transactions'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array, items: rule_schema

        before { create(:recurring_transaction, user: user, category: category) }
        run_test!
      end

      response(401, 'unauthorized') do
        schema type: :object, properties: { error: { type: :string } }

        let(:Authorization) { nil }
        run_test!
      end
    end

    post('create recurring transaction') do
      tags 'Recurring Transactions'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :recurring_transaction, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          amount: { type: :number },
          transaction_type: { type: :string, enum: %w[income expense] },
          category_id: { type: :integer },
          start_on: { type: :string, format: :date },
          active: { type: :boolean }
        },
        required: %w[title amount transaction_type category_id start_on]
      }

      response(201, 'created') do
        schema rule_schema

        let(:recurring_transaction) do
          { recurring_transaction: attributes_for(:recurring_transaction, category_id: category.id) }
        end
        run_test!
      end

      response(422, 'unprocessable entity') do
        schema type: :object, properties: { errors: { type: :array, items: { type: :string } } }

        let(:recurring_transaction) do
          { recurring_transaction: attributes_for(:recurring_transaction, category_id: category.id, title: '') }
        end
        run_test!
      end
    end
  end

  path '/recurring_transactions/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Recurring transaction ID'

    let(:existing_rule) { create(:recurring_transaction, user: user, category: category) }

    put('update recurring transaction') do
      tags 'Recurring Transactions'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :recurring_transaction, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          amount: { type: :number },
          transaction_type: { type: :string, enum: %w[income expense] },
          category_id: { type: :integer },
          start_on: { type: :string, format: :date },
          active: { type: :boolean }
        }
      }

      response(200, 'successful') do
        schema rule_schema

        let(:id) { existing_rule.id }
        let(:recurring_transaction) { { recurring_transaction: { active: false } } }
        run_test!
      end

      response(404, 'not found') do
        schema type: :object, properties: { error: { type: :string } }

        let(:id) { 0 }
        let(:recurring_transaction) { { recurring_transaction: { active: false } } }
        run_test!
      end
    end

    delete('delete recurring transaction') do
      tags 'Recurring Transactions'
      produces 'application/json'

      response(204, 'no content') do
        let(:id) { existing_rule.id }
        run_test!
      end

      response(404, 'not found') do
        schema type: :object, properties: { error: { type: :string } }

        let(:id) { 0 }
        run_test!
      end
    end
  end
end
