defmodule Bank.Accounts do
  alias Bank.Accounts.Create
  alias Bank.Accounts.Get

  defdelegate create(params), to: Create, as: :call
  defdelegate get(id), to: Get, as: :call
end
