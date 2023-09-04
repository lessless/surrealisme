SurrealDB WS client playground.
WSClient code: https://github.com/elixir-mint/mint_web_socket/blob/main/examples/genserver.exs

Connection handling: https://dashbit.co/blog/building-a-new-mysql-adapter-for-ecto-part-iii-dbconnection-integration/

# Surrealisme

```elixir
{:ok, socket} = Surrealisme.Protocol.connect(opts)
WSClient.send_message(socket, Query.select(["article"]))
```
