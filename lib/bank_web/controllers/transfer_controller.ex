defmodule BankWeb.TransferController do
  use BankWeb, :controller

  alias Bank.Transfers
  alias Transfers.Transfer
  alias Bank.Services.AmountValidator
  alias Bank.Services.Paymethod

  alias BankWeb.ErrorJSON

  action_fallback BankWeb.FallbackController

  def create(conn, params) do
    case params do
      %{"account_id" => account_id, "amount" => amount, "paymethod" => paymethod} ->
        with {:ok, decimal_amount} <- AmountValidator.validate_and_parse_amount(amount),
             {:ok, :valid} <- Paymethod.validate(paymethod),
             {:ok, %Transfer{} = transfer} <-
               Transfers.create(%{
                 "account_id" => account_id,
                 "amount" => decimal_amount,
                 "paymethod" => paymethod
               }) do
          conn
          |> put_status(:created)
          |> render(:create, transfer: transfer)
        end

      _ ->
        conn
        |> put_status(:bad_request)
        |> put_view(json: ErrorJSON)
        |> render("error.json", %{message: "Invalid Parameters"})
    end
  end
end
