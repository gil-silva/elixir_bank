defmodule BankWeb.AccountController do
  use BankWeb, :controller

  alias Bank.Accounts
  alias Accounts.Account

  action_fallback BankWeb.FallbackController

  def create(conn, params) do
    params_with_id = Map.merge(params, %{"id" => params["account_id"]})

    with {:ok, %Account{} = account} <- Accounts.create(params_with_id) do
      conn
      |> put_status(:created)
      |> render(:create, account: account)
    end
  end

  def show(conn, params) do
    with {:ok, %Account{} = account} <- Accounts.get(params) do
      conn
      |> put_status(:ok)
      |> render(:get, account: account)
    end
  end
end
