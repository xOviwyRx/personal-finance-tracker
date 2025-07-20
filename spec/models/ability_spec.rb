require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do

  let(:user) { create(:user) }
  let(:ability) { Ability.new(user) }

  context 'user can manage own resources' do

    it 'user can manage own budget' do
      budget = create(:budget, user: user)
      expect(ability).to be_able_to(:manage, budget)
    end

    it 'user can manage own category' do
      category = create(:category, user: user)
      expect(ability).to be_able_to(:manage, category)
    end

    it 'user can manage own transaction' do
      category = create(:category, user: user)
      transaction = create(:transaction, user: user, category: category)
      expect(ability).to be_able_to(:manage, transaction)
    end
  end

  context 'user cannot manage resources of other user' do
    let(:other_user) { create(:user) }

    it 'user cannot manage budget of other user' do
      budget = create(:budget, user: other_user)
      expect(ability).not_to be_able_to(:manage, budget)
    end

    it 'user cannot manage category of other user' do
      category = create(:category, user: other_user)
      expect(ability).not_to be_able_to(:manage, category)
    end

    it 'user cannot manage transaction of other user' do
      category = create(:category, user: other_user)
      transaction = create(:transaction, user: other_user, category: category)
      expect(ability).not_to be_able_to(:manage, transaction)
    end
  end

  context 'guest user (not authenticated)' do
    let(:ability) { Ability.new(nil) }

    it 'cannot manage any resources' do
      budget = create(:budget)
      expect(ability).not_to be_able_to(:manage, budget)
    end
  end
end