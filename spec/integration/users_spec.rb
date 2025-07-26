require 'swagger_helper'

RSpec.describe 'Authentication API', type: :request do
  path '/users/sign_in' do
    post('sign in') do
      tags 'Authentication'
      security []
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'test@example.com' },
              password: { type: :string, example: 'password' }
            }
          }
        },
        required: %w[email password]
      }

      response(200, 'successful sign in') do
        schema type: :object,
               properties: {
                 token: { type: :string, example: 'test_token' },
                 user: {
                   type: :object,
                   properties: {
                     email: { type: :string, example: 'test@example.com' },
                     password: { type: :string, example: 'password' }
                   }
                 }
               }
        run_test!
      end

      response(401, 'invalid credentials') do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Invalid credentials' }
               }

        run_test!
      end
    end
  end

  path '/users/' do
    post('sign up') do
      tags 'Authentication'
      security []
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'test@example.com' },
              password: { type: :string, example: 'password' },
              password_confirmation: { type: :string, example: 'password' }
            }
          }
        },
        required: %w[email password password_confirmation]
      }

      response(201, 'successful sign up') do
        schema type: :object,
               properties: {
                 token: { type: :string, example: 'test_token' },
                 user: {
                   type: :object,
                   properties: {
                     email: { type: :string, example: 'test@example.com' },
                     password: { type: :string, example: 'password' }
                   }
                 }
               }
        run_test!
      end

      response(422, 'validation errors') do
        schema type: :object,
               properties: {
                 errors: {
                   type: :array,
                   items: {
                     type: :string
                   }
                 }
               }
        run_test!
      end
    end
  end

  path '/users/sign_out' do
    delete('sign out') do
      tags 'Authentication'
      description 'Logs out user by revoking their authentication token.'
      consumes 'application/json'
      produces 'application/json'

      response(200, 'successful sign out') do
        schema type: :object,
               properties: {
                 message: { type: :string, example: 'Logged out successfully.' },
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