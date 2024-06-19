defmodule BankWeb.FallbackController do
  use BankWeb, :controller
  alias BankWeb.ErrorJSON

  # Helper function to render error responses
  defp render_error(conn, status, message) do
    conn
    |> put_status(status)
    |> put_view(json: ErrorJSON)
    |> render("error.json", %{message: message})
  end

  # Handle not found errors
  def call(conn, {:error, :not_found}) do
    render_error(conn, :not_found, "Not Found")
  end

  # Handle Ecto changeset errors
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    render_error(conn, :bad_request, Ecto.Changeset.traverse_errors(changeset, &translate_error/1))
  end

  # Handle specific transaction errors
  def call(conn, {:error, :fetch_account_step, _cause, _changeset}) do
    render_error(conn, :not_found, "Account not found!")
  end

  def call(conn, {:error, :verify_balance_step, :balance_too_low, _changeset}) do
    render_error(conn, :bad_request, "Not enough balance!")
  end

  # Handle all other errors
  def call(conn, {:error, _step, cause, _changeset}) do
    render_error(conn, :bad_request, cause)
  end

  # Private function to translate error messages
  defp translate_error({msg, opts}) do
    Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
      opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
    end)
  end
end
