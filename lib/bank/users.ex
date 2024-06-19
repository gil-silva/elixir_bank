defmodule Bank.Users do
  alias Bank.Users.Get

  defdelegate get(id), to: Get, as: :call
end
