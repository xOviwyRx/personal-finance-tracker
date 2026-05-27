require 'rails_helper'

RSpec.describe BudgetAlertJob, type: :job do
  let(:user) { create(:user) }
  let(:category) { create(:category, user: user) }
  let!(:budget) { create(:budget, user: user, category: category, monthly_limit: 500) }

  it 'emails when spending crosses into the approaching tier' do
    tx = create(:transaction, user: user, category: category, amount: 400)
    expect { described_class.perform_now(tx.id) }.to have_enqueued_mail(BudgetAlertMailer, :limit_alert)
  end

  it 'emails again when spending escalates past the limit' do
    described_class.perform_now(create(:transaction, user: user, category: category, amount: 400).id)
    tx = create(:transaction, user: user, category: category, amount: 200)
    expect { described_class.perform_now(tx.id) }.to have_enqueued_mail(BudgetAlertMailer, :limit_alert)
  end

  it 'emails only once while the tier is unchanged' do
    tx = create(:transaction, user: user, category: category, amount: 600)
    expect do
      described_class.perform_now(tx.id)
      described_class.perform_now(tx.id)
    end.to have_enqueued_mail(BudgetAlertMailer, :limit_alert).once
  end
end
