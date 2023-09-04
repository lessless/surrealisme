defmodule Surrealisme.Query do
  def use(ns, db) do
    %{
      id: 1,
      method: "use",
      params: [ns, db]
    }
    |> Jason.encode!()
  end

  def signin(user, pass) do
    %{
      id: 1,
      method: "signin",
      params: [
        %{
          user: user,
          pass: pass
        }
      ]
    }
    |> Jason.encode!()
  end

  def create(collection, params) do
    %{
      id: 1,
      method: "create",
      params: [
        collection,
        params
      ]
    }
    |> Jason.encode!()
  end

  def select(params) do
    %{
      id: 1,
      method: "select",
      params: params
    }
    |> Jason.encode!()
  end
end
