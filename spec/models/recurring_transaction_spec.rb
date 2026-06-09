require 'rails_helper'

RSpec.describe RecurringTransaction do
  let(:user) { create(:user) }
  let(:category) { create(:category, user: user) }

  it 'rejects a category belonging to another user' do
    other_category = create(:category, user: create(:user))
    expect(build(:recurring_transaction, user: user, category: other_category)).not_to be_valid
  end

  it 'rejects a start date in the past' do
    expect(build(:recurring_transaction, user: user, category: category, start_on: Date.current - 1)).not_to be_valid
  end

  it 'sets next_run_on to start_on on create' do
    start_on = Date.current + 7
    rule = create(:recurring_transaction, user: user, category: category, start_on: start_on)
    expect(rule.next_run_on).to eq(start_on)
  end

  describe '#next_transaction_date' do
    it 'advances one month, clamping to month-end without drifting' do
      rule = build(:recurring_transaction, user: user, category: category, start_on: Date.new(2026, 1, 31))
      feb = rule.next_transaction_date(Date.new(2026, 1, 31))
      expect(feb).to eq(Date.new(2026, 2, 28))
      expect(rule.next_transaction_date(feb)).to eq(Date.new(2026, 3, 31))
    end
  end

  describe '.due' do
    it 'returns active rules scheduled today or earlier, excluding future and inactive' do
      due_today = create(:recurring_transaction, user: user, category: category, start_on: Date.current)
      create(:recurring_transaction, user: user, category: category, start_on: Date.current + 5)
      create(:recurring_transaction, user: user, category: category, start_on: Date.current, active: false)

      expect(RecurringTransaction.due).to contain_exactly(due_today)
    end
  end
end
