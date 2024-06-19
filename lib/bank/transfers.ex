defmodule Bank.Transfers do
  alias Bank.Services.Transaction
  defdelegate create(params), to: Transaction, as: :call
end
