defmodule Omega.Client do
  @moduledoc false

  import URI, only: [encode_query: 1]

  @base_uri Application.get_env(:omega, :base_uri, "https://api.omise.co/")
  @http_opts_key :http_options

  defmacro __using__(_) do
    quote do
      @client unquote(__MODULE__)

      def get(path, key, params \\ []) do
        @client.request(:get, path, [key: key, params: params])
      end

      def post(path, key, body) do
        @client.request(:post, path, [key: key, body: body])
      end

      def put(path, key, body) do
        @client.request(:put, path, [key: key, body: body])
      end

      def delete(path, key) do
        @client.request(:delete, path, [key: key])
      end
    end
  end

  def request(method, path, opts) do
    key    = opts[:key]    || raise ArgumentError, ":key must be given"
    body   = opts[:body]   || []
    params = opts[:params] || []

    req_url     = to_charlist(@base_uri <> path <> "?" <> encode_query(params))
    req_headers = [auth_header(key)]
    req_opts    = prepare_request(req_url, req_headers, body)
    http_opts   = prepare_http_options()

    method
    |> :httpc.request(req_opts, http_opts, [])
    |> normalize_response()
  end

  defp prepare_request(req_url, req_headers, []) do
    {req_url, req_headers}
  end
  defp prepare_request(req_url, req_headers, body) do
    {req_url, req_headers, 'application/json', encode_to_json(body)}
  end

  defp prepare_http_options do
    Application.get_env(:omega, @http_opts_key, [])
  end

  defp auth_header(key) do
    {'Authorization', 'Basic ' ++ :base64.encode_to_string("#{key}:")}
  end

  defp normalize_response(response) do
    case response do
      {:ok, {{_http_version, 200, _status}, body}} ->
        {:ok, decode_json_body(body)}

      {:ok, {{_http_version, 200, _status}, _headers, body}} ->
        {:ok, decode_json_body(body)}

      {:ok, {{_http_version, status, _status}, body}} ->
        {:error, status, decode_json_body(body)}

      {:ok, {{_http_version, status, _status}, _headers, body}} ->
        {:error, status, decode_json_body(body)}

      {:error, reason} ->
        {:error, :bad_request, reason}
    end
  end

  defp encode_to_json(body) when is_list(body) or is_map(body) do
    body
    |> Enum.into(%{})
    |> Poison.encode!
  end

  defp decode_json_body(body) do
    Poison.decode!(body)
  end
end
