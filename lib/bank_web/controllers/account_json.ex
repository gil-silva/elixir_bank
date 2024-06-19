defmodule BankWeb.AccountJSON do
  def create(%{account: account}) do
    %{
      account_id: account.account_id,
      balance: Decimal.to_float(account.balance)
    }
  end

  def get(%{account: account}) do
    %{
      account_id: account.id,
      balance: Decimal.to_float(account.balance)
    }
  end
end
