defmodule FsmTest do
  use ExUnit.Case

  test "normal attack to entity" do
    {:ok, sup_pid} = Entity.Supervisor.start_link

    {:ok, entity_pid} = Supervisor.start_child(sup_pid, [:foo, 100])

    Entity.attack(entity_pid, 50)

    assert Entity.status(entity_pid) == {:normal, %Entity{name: :foo, life: 50}}

    Entity.attack(entity_pid, 80)

    assert Entity.status(entity_pid) == {:fainted, %Entity{name: :foo, life: 0}}

  end

  test "poison attack to entity" do
    {:ok, sup_pid} = Entity.Supervisor.start_link

    {:ok, entity_pid} = Supervisor.start_child(sup_pid, [:foo, 100])

    Entity.attack(entity_pid, 50)

    assert Entity.status(entity_pid) == {:normal, %Entity{name: :foo, life: 50}}

    Entity.poison(entity_pid, 20)

    :timer.sleep(1000)

    {:poisoned, state} = Entity.status(entity_pid)
    assert state.life == 30

    :timer.sleep(1000)

    {:poisoned, state} = Entity.status(entity_pid) 
    assert state.life == 10

    Entity.antidote(entity_pid)

    assert Entity.status(entity_pid) == {:normal, %Entity{name: :foo, life: 10}}

  end  
end
