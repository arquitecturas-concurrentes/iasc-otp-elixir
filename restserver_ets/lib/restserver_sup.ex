defmodule RESTServer.Supervisor do
  use Supervisor


  ## Client API

  def start_link(server_name) do
    Supervisor.start_link(__MODULE__, server_name)
  end

  ## Server Callbacks

  def init(server_name) do
    table = :ets.new(:server_ets, [:set, :public])

    children = [
      worker(RESTServer, [server_name, table], restart: :transient),
    ]

    supervise(children, strategy: :one_for_one)
  end

end
