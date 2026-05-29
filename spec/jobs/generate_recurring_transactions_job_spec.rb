require 'rails_helper'

RSpec.describe GenerateRecurringTransactionsJob, type: :job do
  let(:user) { create(:user) }
  let(:category) { create(:category, user: user) }

  it 'creates a transaction for a due rule and advances the schedule' do
    rule = create(:recurring_transaction, user: user, category: category, start_on: Date.current)

    expect { described_class.perform_now }.to change { rule.transactions.count }.by(1)

    transaction = rule.transactions.last
    expect(transaction.date).to eq(Date.current)
    expect(transaction.amount).to eq(rule.amount)
    expect(rule.reload.next_run_on).to be > Date.current
  end

  it 'skips rules that are not yet due or inactive' do
    create(:recurring_transaction, user: user, category: category, start_on: Date.current + 5)
    create(:recurring_transaction, user: user, category: category, start_on: Date.current, active: false)

    expect { described_class.perform_now }.not_to change(Transaction, :count)
  end

  it 'skips missed past months but resumes the schedule in the future' do
    rule = create(:recurring_transaction, user: user, category: category, start_on: Date.current)
    rule.update!(next_run_on: Date.current.prev_month(3).beginning_of_month)

    expect { described_class.perform_now }.not_to change(Transaction, :count)
    expect(rule.reload.next_run_on).to be > Date.current
  end

  it 'does not create a duplicate when run twice the same day' do
    create(:recurring_transaction, user: user, category: category, start_on: Date.current)

    described_class.perform_now
    expect { described_class.perform_now }.not_to change(Transaction, :count)
  end
end
