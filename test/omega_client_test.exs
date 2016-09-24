defmodule OmegaClientTest do
  use ExUnit.Case

  import Mock

  alias Omega.Client

  defmodule Account do
    use Omega.Client

    @endpoint "account"
    @secret_key System.get_env("OMISE_SECRET_KEY") || "skey_xxx"

    def retrieve do
      get(@endpoint, @secret_key)
    end
  end

  test "make request without key given" do
    assert_raise RuntimeError, fn ->
      Client.request(:get, "charges", [])
    end
  end

  test "make request with ok response" do
    with_mock(
      :httpc,
      [request: fn(_, _, _, _) ->
        {:ok, {{'HTTP/1.1', 200, 'OK'}, "{\"object\":\"account\"}"}} end]
    ) do
      assert {:ok, response} = Client.request(:get, "account", [key: "skey_xxx"])
      assert is_map(response)
      assert response["object"] == "account"
    end
  end

  test "make request with error response" do
    with_mock(
      :httpc,
      [request: fn(_, _, _, _) ->
        {:ok, {{'HTTP/1.1', 401, 'Unauthorized'}, "{\"object\":\"error\"}" }} end]
    ) do
      assert {:error, 401, response} = Client.request(:get, "account", [key: "skey_xxx"])
      assert is_map(response)
      assert response["object"] == "error"
    end
  end

  test "make request using Account module" do
    with_mock(
      :httpc,
      [request: fn(_, _, _, _) ->
        {:ok, {{'HTTP/1.1', 200, 'OK'}, "{\"object\":\"account\"}" }} end]
    ) do
      assert {:ok, response} = Account.retrieve
      assert is_map(response)
      assert response["object"] == "account"
    end
  end
end
