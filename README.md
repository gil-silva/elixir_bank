# Elixir Bank

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Endpoints

  #### Create Account

  * `POST` /api/accounts
  * Payload:

  ```bash
    {
      "account_id": 1234567,
      "balance": 500.0
    }
  ```

  * Response:

  ```bash
    {
      "account_id": 1234567,
      "balance": 500.0
    }
  ```

  #### Show Account

  * `GET` /api/accounts?id=1234567

  * Response:

  ```bash
    {
      "account_id": 1234567,
      "balance": 500.0
    }
  ```

  #### Make Transfer

  * `POST` /api/transfers

  * Payload:

  ```bash
    {
        "account_id": 1234567,
        "amount": 10.50,
        "paymethod": "P"
    }
  ```

  * Response:

  ```bash
    {
      "id": 1,
      "description": "Transfered: R$ 10.50, Remaining: R$ 489.50",
      "account_id": 1234567,
      "amount": 10.50,
      "fee_amount": 0.0,
      "original_balance": 500.0,
      "result_balance": 489.5
    }
  ```
