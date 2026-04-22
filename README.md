# Personal Finance Tracker API

A REST API for tracking personal finances with category-based monthly budgets and real-time warnings when transactions approach or exceed their limits.

## Table of Contents

- [Getting Started](#getting-started)
- [Testing the API](#testing-the-api)
   - [Swagger UI Documentation](#swagger-ui-documentation)
   - [Authentication Flow](#authentication-flow)
- [Development](#development)
   - [Code Quality & Testing](#code-quality--testing)
   - [Continuous Integration](#continuous-integration)
- [Tech Stack](#tech-stack)
- [API Endpoints](#api-endpoints)
   - [Authentication](#authentication)
   - [Categories](#categories)
   - [Budgets](#budgets)
   - [Transactions](#transactions)
- [Features](#features)
   - [Budget Monitoring](#budget-monitoring)
- [Roadmap](#roadmap)

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

### Swagger UI Documentation

Interactive API documentation at http://localhost:3000/api-docs

![Swagger UI Screenshot](docs/swagger-ui.png)

### Authentication Flow

1. **Visit** http://localhost:3000/api-docs
2. **Sign up or sign in** using the authentication endpoints
3. **Copy the JWT token** from the response body
4. **Click "Authorize"** button in Swagger UI
5. **Enter:** `Bearer YOUR_JWT_TOKEN`
6. **Test any endpoint** directly in the browser

## Development

### Code Quality & Testing

```bash
docker-compose exec web rubocop
docker-compose exec web rspec
```

### Continuous Integration

![CI](https://github.com/xOviwyRx/personal-finance-tracker/workflows/Ruby%20on%20Rails%20CI/badge.svg)

GitHub Actions runs RuboCop and RSpec against PostgreSQL 15 on every push and pull request to `main`.

## Tech Stack

### Backend
- Ruby 3.3.4
- Ruby on Rails 7.1.0+ (API-only)
- PostgreSQL
- REST API

### Authentication & Authorization
- `has_secure_password` (bcrypt)
- `jwt` gem (hand-rolled JWT with denylist revocation)
- CanCanCan

### API Documentation
- Swagger UI
- RSwag

### Search & Utilities
- Ransack

### Testing & Code Quality
- RSpec
- RuboCop

### DevOps & Deployment
- Docker & Docker Compose
- GitHub Actions CI/CD

## API Endpoints

### Authentication
- `POST /api/v1/users` - Sign up (returns JWT token)
- `POST /api/v1/users/sign_in` - Sign in (returns JWT token)
- `DELETE /api/v1/users/sign_out` - Sign out (revokes JWT token)

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

## Roadmap

Potential improvements for future iterations:
- Monthly spending reports with category breakdown
- Recurring transactions (rent, subscriptions)
- Multi-currency support
- Background processing for budget warnings to reduce request-time cost