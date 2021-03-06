defmodule RESTServer.Supervisor do
  use Supervisor

  ## Client API

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def start_restserver(sup, state \\ []) do
    {:ok, pid} = Supervisor.start_child(sup, state)
    pid
  end

  ## Server Callbacks

  def init([]) do
    children = [
      worker(RESTServer, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
    ##supervise(children, strategy: :simple_one_for_one, max_restarts: 3, max_seconds: 5)
  end

end
