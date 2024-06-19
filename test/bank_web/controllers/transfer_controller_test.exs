defmodule BankWeb.TransferControllerTest do
  use BankWeb.ConnCase
  import Mock
  alias Bank.Transfers.Transfer

  describe "create/2" do
    test "when params are valid create a transfer", %{conn: conn} do
      amount = Decimal.from_float(189.7)
      account_id = 1234
      balance = 500.0
      remaining = 310.3

      with_mock(Bank.Transfers,
        create: fn _params ->
          {:ok,
           %Transfer{
             id: 1,
             amount: amount,
             fee_amount: Decimal.new("0.0"),
             original_balance: Decimal.from_float(balance),
             result_balance: Decimal.new("310.30"),
             description: "Transfered: R$ #{amount}, Remaining: R$ #{remaining}",
             account_id: account_id
           }}
        end
      ) do
        params = %{
          account_id: account_id,
          amount: amount,
          paymethod: "P"
        }

        response =
          conn
          |> post(~p"/api/transfers", params)
          |> json_response(:created)

        assert response == %{
                 "id" => 1,
                 "account_id" => account_id,
                 "amount" => Decimal.to_float(amount),
                 "description" => "Transfered: R$ #{amount}, Remaining: R$ #{remaining}",
                 "fee_amount" => 0.0,
                 "original_balance" => balance,
                 "result_balance" => remaining
               }
      end
    end

    test "when the account is not found, returns an error", %{conn: conn} do
      params = %{
        account_id: 9_999_999,
        amount: 10.0,
        paymethod: "P"
      }

      response =
        conn
        |> post(~p"/api/transfers", params)
        |> json_response(:not_found)

      assert %{"errors" => %{"message" => "Account not found!"}} == response
    end

    test "when the balance is not enough, returns an error", %{conn: conn} do
      account_id = 1234
      {:ok, _account} = Bank.Accounts.Create.call(%{"id" => account_id, "balance" => 10.0})

      params = %{
        account_id: account_id,
        amount: 10.1,
        paymethod: "P"
      }

      response =
        conn
        |> post(~p"/api/transfers", params)
        |> json_response(:bad_request)

      assert %{"errors" => %{"message" => "Not enough balance!"}} == response
    end

    test "when the params are invalid, returns an error", %{conn: conn} do
      params = %{}

      response =
        conn
        |> post(~p"/api/transfers", params)
        |> json_response(:bad_request)

      assert  %{"errors" => %{"message" => "Invalid Parameters"}} == response
    end
  end
end
