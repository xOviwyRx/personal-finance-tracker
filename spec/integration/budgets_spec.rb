require 'swagger_helper'

RSpec.describe 'Budgets API', type: :request do
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
                       name: { type: :string },
                     },
                  }
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

    post('create budgets') do
      tags 'Budgets'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :category, in: :body, schema: {
        type: :object,
        properties: {
          monthly_limit: { type: :string },
          month: { type: :string, format: :date },
          category_id: { type: :integer },
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
                 user_id: { type: :integer },
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


    path '/budgets/{id}' do
      parameter name: :id, in: :path, type: :integer, description: 'Budget ID'

      put('update budget') do
        tags 'Budgets'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :id, in: :body, schema: {
          type: :object,
          properties: {
            monthly_limit: { type: :string },
            month: { type: :string, format: :date },
            category_id: { type: :integer },
          },
          required: ['monthly_limit']
        }

        response(200, 'successful') do
          schema type: :object,
                 properties: {
                   id: { type: :integer },
                   monthly_limit: { type: :string },
                   month: { type: :string, format: :date },
                   category_id: { type: :integer },
                   user_id: { type: :integer },
                   created_at: { type: :string, format: :datetime },
                   updated_at: { type: :string, format: :datetime },
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

        response(404, 'not found') do
          schema type: :object,
                 properties: {
                   error: { type: :string, example: 'Record not found' }
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

      delete('delete budget') do
        tags 'Budgets'
        produces 'application/json'

        response(204, 'no content') do
          run_test!
        end

        response(404, 'not found') do
          schema type: :object,
                 properties: {
                   error: { type: :string }
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
end