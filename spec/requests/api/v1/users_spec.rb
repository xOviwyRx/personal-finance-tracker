require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  # Registration new user
  describe "POST api/v1/users" do
    let(:valid_attributes) do
      {
        user: {
          email: 'test@example.com',
          password: 'password',
          password_confirmation: 'password',
        }
      }
    end

    context 'with valid attributes' do
      it 'creates a new user' do
        expect {
          post '/api/v1/users', params: valid_attributes, as: :json
        }.to change(User, :count).by(1)
      end

      it 'returns success status' do
        post '/api/v1/users', params: valid_attributes, as: :json
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new user with invalid email' do
        invalid_params = {
          user: {
            email: 'invalid-email',
            password: 'password',
            password_confirmation: 'password'
          }
        }

        expect {
          post '/api/v1/users', params: invalid_params, as: :json
        }.not_to change(User, :count)
      end

      it 'does not create a new user with short password' do
        invalid_params = {
          user: {
            email: 'test@example.com',
            password: '123',
            password_confirmation: '123'
          }
        }

        expect {
          post '/api/v1/users', params: invalid_params, as: :json
        }.not_to change(User, :count)
      end

      it 'does not create a user with mismatched password' do
        invalid_params = {
          user: {
            email: 'test@example.com',
            password: 'password',
            password_confirmation: 'pass'
          }
        }
        expect {
          post '/api/v1/users', params: invalid_params, as: :json
        }.not_to change(User, :count)
      end

    end

    context 'response format' do
      it 'returns user data on successful creation' do
        post '/api/v1/users', params: valid_attributes, as: :json

        json_response = JSON.parse(response.body)
        expect(json_response['data']['user']['email']).to eq('test@example.com')
        expect(json_response['status']['code']).to eq(201)
      end

      it 'returns error message for invalid data' do
        invalid_params = { user: { email: 'invalid' } }
        post '/api/v1/users', params: invalid_params, as: :json

        json_response = JSON.parse(response.body)
        expect(json_response['status']['message']).to include("couldn't be created")
      end
    end
  end

end