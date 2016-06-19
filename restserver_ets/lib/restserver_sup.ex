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
    ##supervise(children, strategy: :simple_one_for_one, max_restarts: 3, max_seconds: 5)
  end

end
