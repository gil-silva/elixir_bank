defmodule Bank.Services.TransactionTest do
  use Bank.DataCase, async: true
  alias Bank.Services.Transaction
  alias Bank.Services.Paymethod

  describe "call/1" do
    test "when params are valid, create a transaction" do
      balance = 500.0
      amount = Decimal.from_float(15.0)
      account_id = 1234

      {:ok, _account} = Bank.Accounts.Create.call(%{"id" => account_id, "balance" => balance})

      params = %{"account_id" => account_id, "amount" => amount, "paymethod" => "P"}
      {:ok, transfer} = Transaction.call(params)

      assert transfer.description == "Transferred: R$ 15.00, Remaining: R$ 485.00"
      assert transfer.account_id == account_id
      assert transfer.amount == Decimal.round(amount, 2)
    end

    test "when params are valid, updates the account balance" do
      balance = 200.0
      amount = Decimal.from_float(27.5)
      account_id = 2222

      {:ok, _account} = Bank.Accounts.Create.call(%{"id" => account_id, "balance" => balance})

      params = %{"account_id" => account_id, "amount" => amount, "paymethod" => "P"}
      {:ok, transfer} = Transaction.call(params)

      {:ok, updated_account} = Bank.Accounts.Get.call(%{"id" => account_id})
      new_balance = Decimal.sub(Decimal.from_float(balance), amount)

      assert transfer.description == "Transferred: R$ 27.50, Remaining: R$ 172.50"
      assert transfer.account_id == account_id
      assert transfer.amount == Decimal.round(amount, 2)
      assert updated_account.balance == Decimal.round(new_balance, 2)
      assert updated_account.id == account_id
    end

    test "when the paymethod is PIX, updates the account balance without fee" do
      balance = 100.58
      amount = Decimal.from_float(30.2)
      paymethod = "P"
      account_id = 3333

      {:ok, _account} = Bank.Accounts.Create.call(%{"id" => account_id, "balance" => balance})

      params = %{"account_id" => account_id, "amount" => amount, "paymethod" => paymethod}
      {:ok, transfer} = Transaction.call(params)

      {:ok, updated_account} = Bank.Accounts.Get.call(%{"id" => account_id})
      new_balance = Decimal.sub(Decimal.from_float(balance), amount)

      assert transfer.description == "Transferred: R$ 30.20, Remaining: R$ 70.38"
      assert transfer.amount == Decimal.round(amount, 2)
      assert updated_account.balance == new_balance
    end

    test "when the paymethod is Debit Card, updates the account balance with fee" do
      balance = 100.0
      amount = Decimal.from_float(10.0)
      paymethod = "D"
      amount_with_fee = Paymethod.apply_fee(amount, paymethod)
      account_id = 4444

      {:ok, _account} = Bank.Accounts.Create.call(%{"id" => account_id, "balance" => balance})

      params = %{"account_id" => account_id, "amount" => amount, "paymethod" => paymethod}
      {:ok, transfer} = Transaction.call(params)

      {:ok, updated_account} = Bank.Accounts.Get.call(%{"id" => account_id})
      new_balance = Decimal.sub(Decimal.from_float(balance), amount_with_fee)

      assert transfer.description == "Transferred: R$ 10.00, Remaining: R$ 89.70"
      assert transfer.amount == Decimal.round(amount, 2)
      assert updated_account.balance == new_balance
    end

    test "when the paymethod is Credit Card, updates the account balance with fee" do
      balance = 100.0
      amount = Decimal.from_float(10.0)
      paymethod = "C"
      amount_with_fee = Paymethod.apply_fee(amount, paymethod)
      account_id = 5555

      {:ok, _account} = Bank.Accounts.Create.call(%{"id" => account_id, "balance" => balance})

      params = %{"account_id" => account_id, "amount" => amount, "paymethod" => paymethod}
      {:ok, transfer} = Transaction.call(params)

      {:ok, updated_account} = Bank.Accounts.Get.call(%{"id" => account_id})
      new_balance = Decimal.sub(Decimal.from_float(balance), amount_with_fee)

      assert transfer.description == "Transferred: R$ 10.00, Remaining: R$ 89.50"
      assert transfer.amount == Decimal.round(amount, 2)
      assert updated_account.balance == new_balance
    end

    test "when the account balance is not enough, it does not make the transfer" do
      balance = 17.0
      amount = Decimal.from_float(17.5)
      account_id = 5555

      {:ok, _account} = Bank.Accounts.Create.call(%{"id" => account_id, "balance" => balance})

      params = %{"account_id" => account_id, "amount" => amount, "paymethod" => "P"}
      {:error, step, cause, _results} = Transaction.call(params)

      {:ok, updated_account} = Bank.Accounts.Get.call(%{"id" => account_id})
      original_balance = Decimal.from_float(balance)

      assert step == :verify_balance_step
      assert cause == :balance_too_low
      assert updated_account.balance == original_balance
    end

    test "when the account is not found, it does not make the transfer" do
      amount = Decimal.from_float(300.0)
      account_id = 9_999_999_999

      {:error, :not_found} = Bank.Accounts.Get.call(%{"id" => account_id})

      params = %{"account_id" => account_id, "amount" => amount, "paymethod" => "P"}
      {:error, step, cause, _results} = Transaction.call(params)

      assert step == :fetch_account_step
      assert cause == :not_found
    end
  end
end
