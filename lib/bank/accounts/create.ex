defmodule Bank.Accounts.Create do
  alias Bank.Accounts.Account
  alias Bank.Repo

  def call(params) do
    params
    |> Account.changeset()
    |> Repo.insert()
  end
end
