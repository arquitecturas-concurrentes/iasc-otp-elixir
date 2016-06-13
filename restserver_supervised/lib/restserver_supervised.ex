import RESTServer

defmodule RESTServer.Supervisor do
  use Supervisor

  @name RESTServer.Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def start_restserver(state \\ []) do
    {:ok, pid} = Supervisor.start_child(@name, state)
    pid
  end

  def get_supervisor do
    case RESTServer.Supervisor.start_link do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
      {_, something} -> something
    end
  end

  def get_worker(state \\ []) do
    sup_pid = RESTServer.Supervisor.get_supervisor
    {:ok, pid} = Supervisor.start_child(sup_pid, state)
    pid
  end

  def init(:ok) do
    import Supervisor.Spec

    children = [
      worker(RESTServer, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

end
