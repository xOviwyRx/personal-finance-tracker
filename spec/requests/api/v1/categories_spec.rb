require 'rails_helper'

RSpec.describe "Api::V1::Categories", type: :request do
  let!(:user) { create(:user) }
  let!(:category1) { create(:category, user: user) }
  let!(:category2) { create(:category, user: user, name: 'Electronics') }

  describe "GET /api/v1/categories" do
    it 'returns 401 when not authenticated' do
      get '/api/v1/categories'
      expect(response).to have_http_status(:unauthorized)
    end

    context 'when authenticated' do
      before do
        post '/api/v1/users/sign_in', params: {
          user: { email: user.email, password: user.password }
        }, as: :json
      end

      it 'returns status code 200' do
        get '/api/v1/categories'
        expect(response).to have_http_status(:ok)
      end

      it 'returns all categories without filters' do
        get '/api/v1/categories'

        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(2)
        expect(json_response.first).to have_key('name')
      end

      it 'filters by name' do
        get '/api/v1/categories?q[name_eq]=Food'

        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(1)
        expect(json_response.first['name']).to eq('Food')
      end
    end
  end

  describe "POST /api/v1/categories" do
    it 'returns 401 when not authenticated' do
      post '/api/v1/categories', params: { category: { name: 'Food' } }, as: :json
      expect(response).to have_http_status(:unauthorized)
    end

    context 'when authenticated' do
      before do
        post '/api/v1/users/sign_in', params: {
          user: { email: user.email, password: user.password }
        }, as: :json
      end

      it 'returns success status' do
        post '/api/v1/categories', params: { category: { name: 'Books' } }, as: :json
        expect(response).to have_http_status(:success)
      end

      it 'returns created category' do
        post '/api/v1/categories', params: { category: { name: 'Books' } }, as: :json
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq('Books')
      end

      it 'does not allow creating duplicate category with same user' do
        post '/api/v1/categories', params: { category: { name: 'Electronics' } }, as: :json
        expect(response).to have_http_status(:unprocessable_content)
        json_response = JSON.parse(response.body)
        Rails.logger.debug(json_response['errors'])
        expect(json_response['errors']).to include("Name has already been taken")
      end
    end
  end

  describe "PUT /api/v1/categories/:id" do
    it 'returns 401 when not authenticated' do
      put "/api/v1/categories/#{category1.id}", params: { category: { name: 'Updated' } }, as: :json
      expect(response).to have_http_status(:unauthorized)
    end

    context 'when authenticated' do
      before do
        post '/api/v1/users/sign_in', params: {
          user: { email: user.email, password: user.password }
        }, as: :json
      end

      it 'updates the category successfully' do
        put "/api/v1/categories/#{category1.id}", params: { category: { name: 'Updated Electronics' } }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body["name"]).to eq("Updated Electronics")
        expect(category1.reload.name).to eq("Updated Electronics")
      end
    end

  end

  describe "DELETE /api/v1/categories/:id" do
    it 'returns 401 when not authenticated' do
      delete "/api/v1/categories/#{category1.id}", as: :json
      expect(response).to have_http_status(:unauthorized)
    end

    context 'when authenticated' do
      before do
        post '/api/v1/users/sign_in', params: {
          user: { email: user.email, password: user.password }
        }, as: :json
      end

      it 'deletes the category successfully' do
        delete "/api/v1/categories/#{category1.id}"
        expect(response).to have_http_status(:no_content)
        expect(Category.find_by(id: category1.id)).to be_nil
      end
    end
  end
end
