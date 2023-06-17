defmodule Surrealisme.MixProject do
  use Mix.Project

  def project do
    [
      app: :surrealisme,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:db_connection, "~> 2.0"},
      {:mint_web_socket, "~> 1.0"},
      {:jason, "~>1.0"}
    ]
  end
end
