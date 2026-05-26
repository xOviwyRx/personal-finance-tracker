require 'swagger_helper'

RSpec.describe 'Categories API', type: :request do
  let(:user) { create(:user) }
  let(:Authorization) { "Bearer #{JwtService.encode(user)}" }

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
                   user_id: { type: :integer }
                 }
               }

        before { create(:category, user: user) }

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
                 user_id: { type: :integer }
               }

        let(:category) { { category: { name: 'Groceries' } } }
        run_test!
      end

      response(401, 'unauthorized') do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }

        let(:category) { { category: { name: 'Groceries' } } }
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

        let(:category) { { category: { name: '' } } }
        run_test!
      end
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

      let(:existing_category) { create(:category, user: user) }

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 user_id: { type: :integer },
                 created_at: { type: :string, format: :datetime },
                 updated_at: { type: :string, format: :datetime }
               }

        let(:id) { existing_category.id }
        let(:category) { { category: { name: 'Renamed' } } }
        run_test!
      end

      response(401, 'unauthorized') do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }

        let(:id) { existing_category.id }
        let(:category) { { category: { name: 'Renamed' } } }
        let(:Authorization) { nil }
        run_test!
      end

      response(404, 'not found') do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Record not found' }
               }

        let(:id) { 0 }
        let(:category) { { category: { name: 'Renamed' } } }
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

        let(:id) { existing_category.id }
        let(:category) { { category: { name: '' } } }
        run_test!
      end
    end

    delete('delete category') do
      tags 'Categories'
      produces 'application/json'

      response(204, 'no content') do
        let(:existing_category) { create(:category, user: user) }
        let(:id) { existing_category.id }
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

      response(422, 'unprocessable entity') do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Category cannot be deleted because it has associated transactions' }
               }

        let(:existing_category) { create(:category, user: user) }

        before { create(:transaction, user: user, category: existing_category) }

        let(:id) { existing_category.id }
        run_test!
      end
    end
  end
end
