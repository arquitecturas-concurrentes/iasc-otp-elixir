defmodule ServerTestTest do
  use ExUnit.Case

  test "start supervised worker" do
    worker_pid = RESTServer.Supervisor.get_worker

    assert RESTServer.get(worker_pid, "/document") == {:ok, :not_found}

    assert RESTServer.post(worker_pid, "/document", "aaa") == :ok

    assert RESTServer.get(worker_pid, "/document") == {:ok, "aaa"}
  end

  test "broke supervised worker" do
    worker_pid = RESTServer.Supervisor.get_worker

    # Kill the pid and wait for the notification
    Process.exit(worker_pid, :shutdown)
    assert_receive {:exit, ^worker_pid}
  end
end
