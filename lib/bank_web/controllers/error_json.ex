defmodule BankWeb.ErrorJSON do
  @moduledoc """
  This module is invoked by your endpoint in case of errors on JSON requests.

  See config/config.exs.
  """

  # Custom render function for different status codes
  @spec render(any(), any()) :: map()
  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  @spec error(map()) :: %{
          errors: %{
            optional(:message) => any(),
            optional(atom()) => list() | %{optional(atom()) => any()}
          }
        }
  @doc """
  Custom error response for not found errors.
  """
  def error(%{status: :not_found}) do
    %{errors: %{message: "Not Found"}}
  end

  def error(%{message: msg}) do
    %{errors: %{message: msg}}
  end

  def error(%{changeset: changeset}) do
    %{
      errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
    }
  end

  @doc false
  defp translate_error({msg, opts}) do
    Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
      opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
    end)
  end
end
