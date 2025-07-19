require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  # Registration new user
  describe "POST /api/v1/users" do
    let(:temp_user) { build(:user) }
    let(:valid_attributes) do
      {
        user: {
          email: temp_user.email,
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
            email: temp_user.email,
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
            email: temp_user.email,
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
        expect(json_response['data']['user']['email']).to eq(temp_user.email)
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

  # Sign in
  describe "POST /api/v1/users/sign_in" do
    let!(:temp_user) { create(:user) }

    context 'with valid credentials' do
      let(:valid_credentials) do
        {
          user: {
            email: temp_user.email,
            password: temp_user.password,
          }
        }
      end

      it 'returns success status' do
        post '/api/v1/users/sign_in', params: valid_credentials, as: :json
        expect(response).to have_http_status(:ok)
      end

      it 'returns correct JSON structure' do
        post '/api/v1/users/sign_in', params: valid_credentials, as: :json

        json_response = JSON.parse(response.body)
        expect(json_response['status']['code']).to eq(200)
        expect(json_response['status']['message']).to eq('Logged in successfully.')
        expect(json_response['data']['user']['email']).to eq(temp_user.email)
        expect(json_response['data']['user']['id']).to eq(temp_user.id)
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized status for wrong password' do
        post '/api/v1/users/sign_in', params: {
          user: { email: 'test@example.com', password: 'wrong' }
        }, as: :json

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns unauthorized status for non-existent user' do
        post '/api/v1/users/sign_in', params: {
          user: { email: 'nonexistent@example.com', password: 'password' }
        }, as: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  # Sign out
  describe "DELETE /api/v1/users/sign_out" do
    let!(:user) { create(:user) }

    before do
      # Sign in first
      post '/api/v1/users/sign_in', params: {
        user: { email: user.email, password: user.password }
      }, as: :json
    end

    it 'returns success status' do
      delete '/api/v1/users/sign_out', as: :json
      expect(response).to have_http_status(:ok)
    end

    it 'returns correct JSON structure' do
      delete '/api/v1/users/sign_out', as: :json

      json_response = JSON.parse(response.body)
      expect(json_response['status']['code']).to eq(200)
      expect(json_response['status']['message']).to eq('Logged out successfully.')
    end
  end
end