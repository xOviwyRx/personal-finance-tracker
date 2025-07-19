require 'rails_helper'

RSpec.describe Category, type: :model do
  it 'has name' do
    category = Category.new(name: "Category Name")
    expect(category.name).to eq("Category Name")
  end

  it 'is invalid without name' do
    user = create(:user)
    category = Category.new(user: user)
    expect(category).not_to be_valid
    expect(category.errors[:name]).to include("can't be blank")
  end

  it 'has many transactions' do
    expect(Category.reflect_on_association(:transactions).macro).to eq(:has_many)
  end

  it 'belongs to user' do
    expect(Category.reflect_on_association(:user).macro).to eq(:belongs_to)
  end

  it 'unique name per user' do
    user = create(:user)
    create(:category, user: user)
    duplicate_category = build(:category, user: user)
    expect(duplicate_category).not_to be_valid
  end

  it 'permit create same name with different user' do
    user1 = create(:user)
    user2 = create(:user)
    create(:category, user: user1)
    category2 = build(:category, user: user2)
    expect(category2).to be_valid
  end
end
