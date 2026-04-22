require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "POST /api/v1/users" do
    let(:valid_params) do
      {
        user: {
          email: 'test@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }
    end

    it 'creates a user' do
      expect do
        post '/api/v1/users', params: valid_params
      end.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it 'returns an auth token on success' do
      post '/api/v1/users', params: valid_params
      expect(response.parsed_body['token']).to be_present
    end

    context 'with invalid attributes' do
      it 'rejects invalid email' do
        params = { user: valid_params[:user].merge(email: 'invalid-email') }

        expect { post '/api/v1/users', params: params }.not_to change(User, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'rejects short password' do
        params = { user: valid_params[:user].merge(password: '123', password_confirmation: '123') }

        expect { post '/api/v1/users', params: params }.not_to change(User, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'rejects mismatched password confirmation' do
        params = { user: valid_params[:user].merge(password_confirmation: 'different') }

        expect { post '/api/v1/users', params: params }.not_to change(User, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST /api/v1/users/sign_in" do
    let!(:existing_user) { create(:user) }

    it 'returns a token with valid credentials' do
      post '/api/v1/users/sign_in', params: { user: { email: existing_user.email, password: existing_user.password } }

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['token']).to be_present
    end

    it 'returns 401 with wrong password' do
      post '/api/v1/users/sign_in', params: { user: { email: existing_user.email, password: 'wrong' } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 401 for non-existent user' do
      post '/api/v1/users/sign_in', params: { user: { email: 'nobody@example.com', password: 'password' } }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE /api/v1/users/sign_out" do
    let(:user) { create(:user) }

    it 'signs the user out' do
      delete '/api/v1/users/sign_out', headers: auth_headers_for(user)

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['message']).to eq('Logged out successfully')
    end

    it 'returns 401 without auth' do
      delete '/api/v1/users/sign_out'
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
