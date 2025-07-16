# Personal Finance Tracker API

A Ruby on Rails API for tracking personal finances with budgets, categories, and transactions.

## Setup

1. Clone the repository
2. Install dependencies: `bundle install`
3. Setup database: `rails db:create db:migrate`
4. Run tests: `rspec`
5. Start server: `rails server`

## Tech Stack

- Ruby on Rails (API-only)
- PostgreSQL
- Devise Authentication
- CanCanCan Authorization
- Ransack
- RSpec for testing

## API Endpoints

### Authentication
- `POST /api/v1/users` - Sign up
- `POST /api/v1/users/sign_in` - Sign in
- `DELETE /api/v1/users/sign_out` - Sign out

### Categories
- `GET /api/v1/categories` - List all categories
- `POST /api/v1/categories` - Create a new category
- `PUT /api/v1/categories/:id` - Update a category
- `DELETE /api/v1/categories/:id` - Delete a category

### Budgets
- `GET /api/v1/budgets` - List all budgets
- `POST /api/v1/budgets` - Create a new budget
- `PUT /api/v1/budgets/:id` - Update a budget
- `DELETE /api/v1/budgets/:id` - Delete a budget

### Transactions
- `GET /api/v1/transactions` - List all transactions
- `POST /api/v1/transactions` - Create a new transaction

## Features

### Budget Monitoring
The API includes real-time budget monitoring that provides warnings when creating expense transactions:

- **Budget Exceeded**: Warns when the monthly budget limit is exceeded, showing the overage amount
- **Budget Limit Reached**: Notifies when exactly at the budget limit
- **Approaching Limit**: Alerts when expenses reach 75% of the monthly budget limit

Budget warnings are returned in the transaction creation response:
```json
{
  "transaction": { },
  "warnings": [
    "You have exceeded the budget limit for category 'Food' by 50.0."
  ]
}
```

*Note: The current budget monitoring implementation will be optimized for better performance in future iterations.*

## Status

🚧 Work in Progress
- ✅ User authentication (Devise)
- ✅ Categories CRUD
- ✅ Budgets CRUD
- ✅ Transactions Create & Read
- ✅ User associations and data scoping
- ✅ RSpec tests (Models, Requests)
- ✅ Ransack search functionality (Categories)
- ✅ RSpec tests (Ransack)
- ✅ CanCanCan
- ✅ Budget monitoring and warnings
- ⏳ RSpec tests (CanCanCan)
- 🔄 Budget monitoring optimization
