defmodule BankWeb.AccountControllerTest do
  use BankWeb.ConnCase

  describe "create/2" do
    test "when params are valid create an account", %{conn: conn} do
      params = %{
        account_id: 1234,
        balance: 189.70
      }

      response =
        conn
        |> post(~p"/api/accounts", params)
        |> json_response(:created)

      assert %{"account_id" => 1234, "balance" => 189.7} == response
    end

    test "when balance is negative, returns an error", %{conn: conn} do
      params = %{
        account_id: 1234,
        balance: -189.70
      }

      response =
        conn
        |> post(~p"/api/accounts", params)
        |> json_response(:bad_request)

      assert %{"errors" => %{"message" => %{"balance" => ["must be greater than or equal to 0"]}}} == response
    end

    test "when balance is missing in params, returns an error", %{conn: conn} do
      params = %{
        account_id: 1234
      }

      response =
        conn
        |> post(~p"/api/accounts", params)
        |> json_response(:bad_request)

      assert%{"errors" => %{"message" => %{"balance" => ["can't be blank"]}}} == response
    end

    test "when account_id is missing in params, returns an error", %{conn: conn} do
      params = %{
        balance: 189.70
      }

      response =
        conn
        |> post(~p"/api/accounts", params)
        |> json_response(:bad_request)

      assert %{"errors" => %{"message" => %{"id" => ["can't be blank"]}}} == response
    end
  end

  describe "show/2" do
    test "when params are valid, return an account", %{conn: conn} do
      {:ok, account} = Bank.Accounts.Create.call(%{"id" => 1_234_567, "balance" => 500.0})
      account_id = account.id

      response =
        conn
        |> get(~p"/api/accounts?id=#{account_id}")
        |> json_response(:ok)

      assert %{"account_id" => 1234567, "balance" => 500.0} == response
    end

    test "when the account is not found, return 404 status", %{conn: conn} do
      response =
        conn
        |> get(~p"/api/accounts?id=#{999_999_999}")
        |> json_response(:not_found)

      assert %{"errors" => %{"message" => "Not Found"}} == response
    end

    test "when the id is not at the query string, return 404 status", %{conn: conn} do
      response =
        conn
        |> get(~p"/api/accounts?")
        |> json_response(:not_found)

      assert %{"errors" => %{"message" => "Not Found"}} == response
    end
  end
end
