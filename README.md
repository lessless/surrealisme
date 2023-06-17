# Surrealisme

```elixir
{:ok, conn, socket, ref}  = Surrealisme.connect()
 Surrealisme.query(conn, socket, ref, "SELECT * From users;")
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `surrealisme` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:surrealisme, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/surrealisme>.
