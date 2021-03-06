defmodule Yatzee.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Yatzee.GameRegistry},
      Yatzee.GameSupervisor
    ]

    :ets.new(:games_table, [:public, :named_table])

    opts = [strategy: :one_for_one, name: Yatzee.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
