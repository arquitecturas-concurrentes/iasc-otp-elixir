defmodule RESTServer do
  use GenServer

  ## Client API

  def start_link(name, ets) do
    GenServer.start_link(__MODULE__, ets, [name: name])
  end

  def get(server, url) do
    GenServer.call(server, {:get, url})
  end

  def post(server, url, body) do
    GenServer.cast(server, {:post, url, body})
  end

  def put(server, url, body) do
    GenServer.cast(server, {:put, url, body})
  end

  def delete(server, url) do
    GenServer.cast(server, {:delete, url})
  end

  def break(server) do
    Process.exit(server, :shutdown)
  end

  ## Server Callbacks

  def init(ets) do
    {:ok, ets}
  end

  def handle_call({:get, url}, _from, ets) do
    case :ets.lookup(ets, url) do
      [{^url, document}] -> {:reply, {:ok, document}, ets}
      [] -> {:reply, {:ok, :not_found}, ets}
    end 
  end

  def handle_cast({:post, url, body}, ets) do
    :ets.insert(ets, {url, body})
    {:noreply, ets}
  end

  def handle_cast({:put, url, body}, ets) do
    :ets.insert(ets, {url, body})
    {:noreply, ets}
  end

  def handle_cast({:delete, url}, ets) do
    :ets.delete(ets, url)
    {:noreply, ets}
  end

  def handle_info(_msg, ets) do
    IO.puts "Message not understood :("
    {:noreply, ets}
  end
end
