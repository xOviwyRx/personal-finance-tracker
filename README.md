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

## Status

🚧 Work in Progress
- ✅ User authentication (Devise)
- ✅ Categories CRUD
- ✅ Budgets CRUD
- ✅ Transactions Create & Read
- ✅ User associations and data scoping
- ✅ RSpec tests (Models)
- ⏳ RSpec tests (Controllers/Requests)
- ⏳ Ransack search functionality
