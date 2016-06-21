defmodule Entity.Supervisor do
  use Supervisor

  ## Client API

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  ## Server Callbacks

  def init([]) do
    children = [
      worker(Entity, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
    ##supervise(children, strategy: :simple_one_for_one, max_restarts: 3, max_seconds: 5)
  end

end
