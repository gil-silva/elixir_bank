defmodule Bank.Users.Get do
  alias Bank.Users.User
  alias Bank.Repo

  def call(%{"id" => ""}) do
    {:error, :not_found}
  end

  def call(%{"id" => user_id}) do
    case Repo.get(User, user_id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def call(%{}) do
    {:error, :not_found}
  end
end
