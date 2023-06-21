SurrealDB WS client playground. All WS code is taken from Phoenix https://github.com/phoenixframework/phoenix/blob/main/test/support/websocket_client.exs

# Surrealisme

```elixir
 {:ok, socket} = Surrealisme.WebsocketClient.connect(self(),"ws://localhost:8000/rpc", :none)
 Surrealisme.WebsocketClient.send(socket, {:text, "query"})
 :erlang.process_info(self(), :messages)
```
