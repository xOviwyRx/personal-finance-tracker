require 'swagger_helper'

RSpec.describe 'Budgets API', type: :request do
  let(:user) { create(:user) }
  let(:Authorization) { "Bearer #{JwtService.encode(user)}" }
  let(:category) { create(:category, user: user) }

  path '/budgets' do
    get('list budgets') do
      tags 'Budgets'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   monthly_limit: { type: :string },
                   month: { type: :string, format: :date },
                   category_id: { type: :integer },
                   created_at: { type: :string, format: :datetime },
                   updated_at: { type: :string, format: :datetime },
                   user_id: { type: :integer },
                   category: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       name: { type: :string }
                     }
                   }
                 }
               }

        before { create(:budget, user: user, category: category) }

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

    post('create budgets') do
      tags 'Budgets'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :budget, in: :body, schema: {
        type: :object,
        properties: {
          monthly_limit: { type: :string },
          month: { type: :string, format: :date },
          category_id: { type: :integer }
        },
        required: ['monthly_limit']
      }

      response(201, 'created') do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 monthly_limit: { type: :string },
                 month: { type: :string, format: :date },
                 category_id: { type: :integer },
                 created_at: { type: :string, format: :datetime },
                 updated_at: { type: :string, format: :datetime },
                 user_id: { type: :integer }
               }

        let(:budget) { { budget: attributes_for(:budget).merge(category_id: category.id) } }
        run_test!
      end

      response(401, 'unauthorized') do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }

        let(:budget) { { budget: { monthly_limit: '500.0' } } }
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

        let(:budget) { { budget: { category_id: category.id } } }
        run_test!
      end
    end
  end

  path '/budgets/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Budget ID'

    put('update budget') do
      tags 'Budgets'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :budget, in: :body, schema: {
        type: :object,
        properties: {
          monthly_limit: { type: :string },
          month: { type: :string, format: :date },
          category_id: { type: :integer }
        },
        required: ['monthly_limit']
      }

      let(:existing_budget) { create(:budget, user: user, category: category) }

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 monthly_limit: { type: :string },
                 month: { type: :string, format: :date },
                 category_id: { type: :integer },
                 user_id: { type: :integer },
                 created_at: { type: :string, format: :datetime },
                 updated_at: { type: :string, format: :datetime }
               }

        let(:id) { existing_budget.id }
        let(:budget) { { budget: { monthly_limit: '750.0' } } }
        run_test!
      end

      response(401, 'unauthorized') do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }

        let(:id) { existing_budget.id }
        let(:budget) { { budget: { monthly_limit: '750.0' } } }
        let(:Authorization) { nil }
        run_test!
      end

      response(404, 'not found') do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Record not found' }
               }

        let(:id) { 0 }
        let(:budget) { { budget: { monthly_limit: '750.0' } } }
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

        let(:id) { existing_budget.id }
        let(:budget) { { budget: { monthly_limit: nil } } }
        run_test!
      end
    end

    delete('delete budget') do
      tags 'Budgets'
      produces 'application/json'

      let(:existing_budget) { create(:budget, user: user, category: category) }

      response(204, 'no content') do
        let(:id) { existing_budget.id }
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

      response(401, 'unauthorized') do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }

        let(:id) { existing_budget.id }
        let(:Authorization) { nil }
        run_test!
      end
    end
  end
end
