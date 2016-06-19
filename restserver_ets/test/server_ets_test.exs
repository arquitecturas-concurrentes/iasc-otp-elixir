defmodule ServerEtsTest do
  use ExUnit.Case

  test "start supervised worker" do
    {:ok, _sup_pid} = RESTServer.Supervisor.start_link(:server)

    assert RESTServer.get(:server, "/document") == {:ok, :not_found}

    assert RESTServer.post(:server, "/document", "aaa") == :ok

    assert RESTServer.get(:server, "/document") == {:ok, "aaa"}
  end

  test "preserve the state depite the reset of the worker" do
    {:ok, _sup_pid} = RESTServer.Supervisor.start_link(:server)
    assert RESTServer.post(:server, "/document", "aaa") == :ok

    # Finish the server in an abnormal way
    GenServer.stop(:server, :kill)
    :timer.sleep(500)

    assert RESTServer.get(:server, "/document") == {:ok, "aaa"}
  end
end
