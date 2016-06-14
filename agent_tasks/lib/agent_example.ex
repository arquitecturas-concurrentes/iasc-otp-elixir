defmodule TODOAgent do

  def start_link(name \\ nil) do
    if name do
      Agent.start_link(fn -> %{} end, name: name)
    else
      Agent.start_link(fn -> %{} end)
    end
  end

  def get_state(list, task) do
    Agent.get(list, &Map.get(&1, task))
  end

  def add_task(list, task, status \\ :pending) do
    Agent.update(list, &Map.put(&1, task, status))
  end

  def tasks_by_status(list, status) do
    Agent.get(list, fn tasks ->
                      Enum.filter tasks, fn { k, v } -> v && v==status end
                    end)
  end

  def update_task(list, task, status) do
    Agent.update(list, &Map.put(&1, task, status))
  end

end
