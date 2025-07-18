# Personal Finance Tracker API

A Ruby on Rails API for tracking personal finances with budgets, categories, and transactions.

## Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/xOviwyRx/personal-finance-tracker.git
   cd personal-finance-tracker
   ```

2. **Build and run with Docker**
   ```bash
   docker-compose up --build
   ```

3. **Set up the database** (in another terminal)
   ```bash
   docker-compose exec web rails db:create db:migrate
   ```

## Testing the API

Use **Postman** or **curl** to test the API endpoints. **Authentication is required** for all endpoints:

```bash
# 1. Sign up
curl -X POST http://localhost:3000/api/v1/users \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "password123"}'

# 2. Use the API
curl -X GET http://localhost:3000/api/v1/categories

# 3. Example: Create a new category
curl -X POST http://localhost:3000/api/v1/categories \
  -H "Content-Type: application/json" \
  -d '{"name": "Food", "description": "Food expenses"}'

# Note: If you need to sign in later, use:
curl -X POST http://localhost:3000/api/v1/users/sign_in \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "password123"}'
```

## Tech Stack

- Ruby on Rails (API-only)
- PostgreSQL
- Docker & Docker Compose
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
- ✅ Docker containerization
- ⏳ RSpec tests (CanCanCan)
- 🔄 Budget monitoring optimization