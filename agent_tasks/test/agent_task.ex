defmodule RandomAgent do
    def start_link do
        Agent.start_link(fn -> {init_random, 100} end, name: __MODULE__)
    end

    def number do
        Agent.get_and_update(__MODULE__, fn(v) -> get_number(v) end)
    end

    def get_number({_v, 0}) do
        [h|t] = init_random
        {h, {t, 99}}
    end
    def get_number({[h|t], n}) do
        {h, {t, n - 1}}
    end

    def init_random do
        basic = [5,4,4,4,4,4] ++ List.duplicate(3,15) ++ List.duplicate(2,20) ++ List.duplicate(0,59)
                :random.seed(:os.timestamp)
        Enum.shuffle(basic)
    end
end

defmodule RandomTask do
  def test do
    task = Task.async(fn -> Display.show() end)
    result = Task.await(task)
    IO.puts "Result of display #{result}"
  end

  def show do
    case RandAgent.number do
        5 -> ['7', '7', '7']
        4 -> [random, '2', '1']
        3 -> ['4', random, '7']
        2 -> ['1', '3', random]
        _ -> [random, random, random]
    end
  end
end
