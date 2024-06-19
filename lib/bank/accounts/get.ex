defmodule Bank.Accounts.Get do
  alias Bank.Accounts.Account
  alias Bank.Repo

  def call(%{"id" => ""}) do
    {:error, :not_found}
  end

  def call(%{"id" => account_id}) do
    case Repo.get(Account, account_id) do
      nil -> {:error, :not_found}
      account -> {:ok, account}
    end
  end

  def call(%{}) do
    {:error, :not_found}
  end
end
