require 'swagger_helper'

RSpec.describe 'Categories API', type: :request do
  path '/categories' do
    get('list categories') do
      tags 'Categories'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   created_at: { type: :string, format: :datetime },
                   updated_at: { type: :string, format: :datetime },
                   user_id: { type: :integer },
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

    post('create category') do
      tags 'Categories'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :category, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      response(201, 'created') do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
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


    path '/categories/{id}' do
      parameter name: :id, in: :path, type: :integer, description: 'Category ID'

      put('update category') do
        tags 'Categories'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :category, in: :body, schema: {
          type: :object,
          properties: {
            name: { type: :string }
          },
          required: ['name']
        }

        response(200, 'successful') do
          schema type: :object,
                 properties: {
                   id: { type: :integer },
                   name: { type: :string },
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

      delete('delete category') do
        tags 'Categories'
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

        response(422, 'unprocessable entity') do
          schema type: :object,
                 properties: {
                   error: { type: :string, example: 'Category cannot be deleted because it has associated transactions' }
                 }
          run_test!
        end
      end
    end
  end
end