defmodule Omega do
  @moduledoc """
  Module wrapper for making Omise API clients.
  Check out [Omise API Reference](https://www.omise.co/api-reference).

  ## Examples

      defmodule MyApp.OmiseClient.Charge do
        use Omega.Client

        @endpoint "charges"

        def list(key, params \\ []) do
          get(@endpoint, key, params)
        end
      end

      $ iex -S mix
      iex> MyApp.OmiseClient.Charge.list("skey_xxx", limit: 10, offset: 5)
  """
end
