defmodule TODOAgentTest do
  use ExUnit.Case

  setup do
    {:ok, list} = TODOAgent.start_link
    {:ok, list: list}
  end

  test "the truth about TODO's", %{list: list} do
    assert TODOAgent.get_state(list, "buy milk") == nil

    TODOAgent.add_task(list, "buy milk", 2)

    assert TODOAgent.get_state(list, "buy milk") == 2
  end

  test "test the filtered state", %{list: list} do
    TODOAgent.add_task(list, "buy milk", :pending)
    TODOAgent.add_task(list, "have the car cleaned", :pending)
    TODOAgent.add_task(list, "work on the scala excercises", :pending)
    TODOAgent.add_task(list, "clean house", :done)

    assert TODOAgent.tasks_by_status(list, :pending) == [{"buy milk", :pending}, {"have the car cleaned", :pending}, {"work on the scala excercises", :pending}]
    assert TODOAgent.tasks_by_status(list, :done) == [{"clean house", :done}]
  end

  test "test update task", %{list: list} do
    TODOAgent.add_task(list, "buy milk", :pending)
    assert TODOAgent.get_state(list, "buy milk") == :pending

    TODOAgent.update_task(list, "buy milk", :done)
    assert TODOAgent.get_state(list, "buy milk") == :done
  end
end
