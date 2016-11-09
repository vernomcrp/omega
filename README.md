# Omega
[![Build Status](https://travis-ci.org/teerawat1992/omega.svg)](https://travis-ci.org/teerawat1992/omega)
[![Hex.pm](https://img.shields.io/hexpm/v/omega.svg?style=flat-square)](https://hex.pm/packages/omega)

Module wrapper for making Omise API clients.
Check out [Omise API Reference](https://www.omise.co/api-reference).

## Installation

  1. Add omega to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:omega, "~> 0.1"}]
  end
  ```

  2. Ensure omise is started before your application:

  ```elixir
  def application do
    [applications: [:omega]]
  end
  ```

  3. Run `mix deps.get`

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

## HTTP Configuration

To configure the HTTP options, you could optionally add `:http_options` key to the
`omega` configuration. For a full list of the available options, please check [Erlang httpc library](http://erlang.org/doc/man/httpc.html)

```elixir
config :omega,
  http_options: [timeout: 10_000, connection_timeout: 10_000]
```
