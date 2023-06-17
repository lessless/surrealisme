defmodule Surrealisme do
  defmodule Config do
    defstruct [:host, :port, :protocol]
  end

  def connect() do
    %Config{
      protocol: :http,
      host: "localhost",
      port: 8000
    }
    |> connect()
  end

  # copy-pasted straight outta https://github.com/elixir-mint/mint_web_socket#usage
  def connect(config) do
    {:ok, conn} = Mint.HTTP.connect(config.protocol, config.host, config.port)
    {:ok, conn, ref} = Mint.WebSocket.upgrade(:ws, conn, "/rpc", [])
    http_get_message = receive(do: (message -> message))

    {:ok, conn, [{:status, ^ref, status}, {:headers, ^ref, resp_headers}, {:done, ^ref}]} =
      Mint.WebSocket.stream(conn, http_get_message)

    {:ok, conn, socket} = Mint.WebSocket.new(conn, ref, status, resp_headers)
    {:ok, conn, socket, ref}
  end

  # c&p from https://github.com/elixir-mint/mint_web_socket/blob/main/examples/echo.exs
  def query(conn, socket, ref, query_str) do
    {:ok, conn, socket, ref} = send_ws(conn, socket, ref, query_str)
    {:ok, conn, socket, frames} = receive_ws(conn, socket, ref)
    {:ok, conn, socket, frames}
  end

  def send_ws(conn, socket, ref, query_str) do
    frame = {:text, query_str}
    {:ok, socket, data} = Mint.WebSocket.encode(socket, frame)
    {:ok, conn} = Mint.WebSocket.stream_request_body(conn, ref, data)
    {:ok, conn, socket, ref}
  end

  # def receive_ws(conn, socket, ref) do
  #   message = receive(do: (message -> message))
  #   {:ok, conn, [{:data, ^ref, data}]} = Mint.WebSocket.stream(conn, message)
  #   {:ok, socket, frames} = Mint.WebSocket.decode(socket, data)
  #   {:ok, conn, socket, frames}
  # end

  def receive_ws(conn, socket, ref) do
    {:ok, conn, frames} = Mint.WebSocket.decode(socket)
    receive_frames(conn, socket, ref, frames)
  end

  defp receive_frames(conn, socket, ref, frames) do
    case frames do
      [] ->
        message = receive(do: (message -> message))
        {:ok, conn, [{:data, ^ref, data}]} = Mint.WebSocket.stream(conn, message)
        receive_frames(conn, socket, ref, Mint.WebSocket.decode(socket, data))

      _ ->
        {:ok, conn, socket, frames}
    end
  end
end
