require 'swagger_helper'

RSpec.describe 'Authentication API', type: :request do
  path '/users/sign_in' do
    post('sign in') do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'user@example.com' },
              password: { type: :string, example: 'password123' }
            }
          }
        },
        required: %w[email password]
      }

      response(200, 'successful sign in') do
        schema type: :object,
               properties: {
                 status: {
                   type: :object,
                   properties: {
                     code: { type: :integer, example: 200 },
                     message: { type: :string, example: 'Logged in successfully.' },
                   },
                 },
                 data: {
                   type: :object,
                   properties: {
                     user: {
                       type: :object,
                       properties: {
                         email: { type: :string, example: 'user@example.com' },
                         password: { type: :string, example: 'password123' }
                       }
                     }
                   }
                 }
               }
        run_test!
      end

      response(401, 'invalid credentials') do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Error message' }
               }

        run_test!
      end
    end
  end

  path '/users/' do
    post('sign up') do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'newuser@example.com' },
              password: { type: :string, example: 'password123' },
              password_confirmation: { type: :string, example: 'password123' }
            }
          }
        },
        required: %w[email password password_confirmation]
      }

      response(201, 'successful sign up') do
        schema type: :object,
               properties: {
                 status: {
                   type: :object,
                   properties: {
                     code: { type: :integer, example: 201 },
                     message: { type: :string, example: 'Signed up successfully.' },
                   },
                 },
                 data: {
                   type: :object,
                   properties: {
                     user: {
                       type: :object,
                       properties: {
                         email: { type: :string, example: 'newuser@example.com' },
                         password: { type: :string, example: 'password123' }
                       }
                     }
                   }
                 }
               }
        run_test!
      end

      response(422, 'validation errors') do
        schema type: :object,
               properties: {
                 status: {
                   type: :object,
                   properties: {
                     message: { type: :string , example: 'Error message' },
                   }
                 }
               }
        run_test!
      end
    end
  end
end