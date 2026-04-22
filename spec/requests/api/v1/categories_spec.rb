require 'rails_helper'

RSpec.describe "Api::V1::Categories", type: :request do
  let(:user) { create(:user) }
  let(:headers) { auth_headers_for(user) }

  describe "GET /api/v1/categories" do
    it 'returns 401 without auth' do
      get '/api/v1/categories'
      expect(response).to have_http_status(:unauthorized)
    end

    context 'with existing categories' do
      let!(:food) { create(:category, user: user, name: 'Food') }
      let!(:electronics) { create(:category, user: user, name: 'Electronics') }

      it "returns user's categories" do
        get '/api/v1/categories', headers: headers
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body.length).to eq(2)
      end

      it 'filters by name' do
        get '/api/v1/categories?q[name_eq]=Food', headers: headers
        expect(response.parsed_body.length).to eq(1)
      end
    end

    it "does not return other users' categories" do
      other_user = create(:user)
      create(:category, user: other_user)

      get '/api/v1/categories', headers: headers
      expect(response.parsed_body).to be_empty
    end
  end

  describe "POST /api/v1/categories" do
    it 'returns 401 without auth' do
      post '/api/v1/categories', params: { category: { name: 'Books' } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'creates a category' do
      expect do
        post '/api/v1/categories', params: { category: { name: 'Books' } }, headers: headers
      end.to change(Category, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it 'rejects duplicate name for same user' do
      create(:category, user: user, name: 'Electronics')

      post '/api/v1/categories', params: { category: { name: 'Electronics' } }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PUT /api/v1/categories/:id" do
    let!(:category) { create(:category, user: user) }

    it 'returns 401 without auth' do
      put "/api/v1/categories/#{category.id}", params: { category: { name: 'Updated' } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'updates the category' do
      put "/api/v1/categories/#{category.id}", params: { category: { name: 'Renamed' } }, headers: headers

      expect(response).to have_http_status(:ok)
      expect(category.reload.name).to eq('Renamed')
    end
  end

  describe 'DELETE /api/v1/categories/:id' do
    let!(:category) { create(:category, user: user) }

    it 'returns 401 without auth' do
      delete "/api/v1/categories/#{category.id}"
      expect(response).to have_http_status(:unauthorized)
    end

    it 'deletes the category' do
      expect do
        delete "/api/v1/categories/#{category.id}", headers: headers
      end.to change(Category, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
