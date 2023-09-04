defmodule Surrealisme.Protocol do
  use DBConnection
  alias Surrealisme.Query
  alias Surrealisme.WSClient
  defstruct [:socket]

  @moduledoc """
  https://dashbit.co/blog/building-a-new-mysql-adapter-for-ecto-part-iii-dbconnection-integration/
  """

  @impl true
  def connect(opts) do
    opts = parse(opts)

    case Surrealisme.WSClient.connect(opts.url) do
      {:ok, socket} ->
        handshake(opts, %__MODULE__{socket: socket})

      {:error, reason} ->
        {:error, %Surrealisme.Error{message: "error when connecting to #{opts.url} : #{inspect(reason)}"}}
    end
  end

  @impl true
  def checkout(state) do
    {:ok, state}
  end

  @impl true
  def ping(state) do
    {:ok, state}
  end

  defp handshake(opts, state) do
    :ok = WSClient.send_message(state.socket, Query.use(opts.ns, opts.db))
    :ok = WSClient.send_message(state.socket, Query.signin(opts.user, opts.pass))

    {:ok, state.socket}
  end

  defp parse(opts) do
    # "ws://root:root@localhost:8000/rpc?ns=test&db=test"
    connection_string =
      Keyword.get(
        opts,
        :connection_string,
        System.get_env("SURREALDB_URL")
      ) ||
        raise "SurrealDB connection string is missing"

    uri = URI.parse(connection_string)
    [user, password] = String.split(uri.userinfo, ":")
    query_params = URI.decode_query(uri.query)

    %{
      url: "#{uri.scheme}://#{uri.host}:#{uri.port}#{uri.path}",
      user: user,
      pass: password,
      ns: Map.fetch!(query_params, "ns"),
      db: Map.fetch!(query_params, "db")
    }
  end
end
