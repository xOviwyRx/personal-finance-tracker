require 'rails_helper'

RSpec.describe BudgetAlertMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:category) { create(:category, user: user, name: 'Groceries') }

  describe '#limit_alert' do
    it 'renders the exceeded alert subject and body' do
      budget = create(:budget, user: user, category: category, monthly_limit: 500, alerted_status: :exceeded)
      mail = described_class.limit_alert(budget)

      expect(mail.subject).to eq("You've reached your Groceries budget")
      expect(mail.body.encoded).to include('Groceries').and include('500')
    end

    it 'uses the approaching subject when approaching' do
      budget = create(:budget, user: user, category: category, alerted_status: :approaching)
      expect(described_class.limit_alert(budget).subject).to eq("You're approaching your Groceries budget")
    end

    it 'refuses to build an email for a non-alert status' do
      budget = create(:budget, user: user, category: category)
      expect { described_class.limit_alert(budget).deliver_now }.to raise_error(ArgumentError)
    end
  end
end
