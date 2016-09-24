# Omega

Module wrapper for making Omise API clients.

## Examples

```elixir
# config/config.exs
config :my_app,
  omise_secret_key: "skey_xxx"

# lib/omise_client/charge.ex
defmodule MyApp.OmiseClient.Charge do
  use Omega.Client

  @endpoint "charges"
  @secret_key Application.get_env(:my_app, :omise_secret_key)

  def list(params \\ []) do
    get(@endpoint, @secret_key, params)
  end

  def retrieve(id, params \\ []) do
    get("#{@endpoint}/#{id}", @secret_key, params)
  end
end
```

```shell
$ iex -S mix
iex> MyApp.OmiseClient.Charge.list(limit: 10, offset: 5)
```
