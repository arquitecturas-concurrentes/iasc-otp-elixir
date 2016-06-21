defmodule Entity do  
  @behaviour :gen_fsm

  defstruct [:life, :name, :poison_timer]

  # ------- Client API

  def start_link(name, life) do
    :gen_fsm.start_link(__MODULE__, %Entity{name: name, life: life, poison_timer: nil}, [])
  end

  def attack(entity, damage) do
    :gen_fsm.send_event(entity, {:attacked, damage})
  end

  def poison(entity, damage) do
    :gen_fsm.send_event(entity, {:poison, damage})
  end

  def antidote(entity) do
    :gen_fsm.send_event(entity, :antidote)
  end

  def status(entity) do
    :gen_fsm.sync_send_event(entity, :status)
  end

  # ------- Server

  def init(initial_state) do
    {:ok, :normal, initial_state}    
  end

  def normal({:attacked, damage}, state) do
    if state.life <= damage do
      {:next_state, :fainted, %{state | life: 0}}
    else
      {:next_state, :normal, %{state | life: (state.life - damage)}}  
    end  
  end

  def normal(:status, _from, state) do
    {:reply, {:normal, state}, :normal, state}
  end

  def normal({:poison, damage}, state) do
    ref = :gen_fsm.send_event_after(1000, {:poison_damage, damage})
    {:next_state, :poisoned, %{state | poison_timer: ref}}
  end

  def poisoned({:poison_damage, damage}, state) do
    if state.life <= damage do
      :gen_fsm.cancel_timer(state.poison_timer)
      {:next_state, :fainted, %{state | life: 0, poison_damage: nil}}
    else
      ref = :gen_fsm.send_event_after(1000, {:poison_damage, damage})
      {:next_state, :poisoned, %{state | life: (state.life - damage), poison_timer: ref}}  
    end      
  end

  def poisoned({:attacked, damage}, state) do
    if state.life <= damage do
      {:next_state, :fainted, %{state | life: 0}}
    else
      {:next_state, :poisoned, %{state | life: (state.life - damage)}}  
    end  
  end

  def poisoned(:antidote, state) do
    :gen_fsm.cancel_timer(state.poison_timer)
    {:next_state, :normal, %{state | poison_timer: nil}}   
  end

  def poisoned(:status, _from, state) do
    {:reply, {:poisoned, state}, :poisoned, state}
  end

  def fainted(:status, _from, state) do
    {:reply, {:fainted, state}, :fainted, state}
  end

  def fainted(_, state) do
    IO.puts "I can't process the event. I fainted :("
    {:next_state, :fainted, state}
  end

  def terminate(reason, _stateName, _state) do
    IO.puts "Process terminated due #{reason}"
  end
end  