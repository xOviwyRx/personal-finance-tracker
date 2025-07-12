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

### Categories
- `GET /api/v1/categories` - List all categories
- `POST /api/v1/categories` - Create a new category
- `PUT /api/v1/categories/:id` - Update a category
- `DELETE /api/v1/categories/:id` - Delete a category

## Status

🚧 Work in Progress
- ✅ User authentication (Devise)
- ✅ Categories CRUD
- ✅ Budgets CRUD
- ⏳ Transactions CRUD
