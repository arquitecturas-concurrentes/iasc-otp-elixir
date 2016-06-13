defmodule Scrapper.OTP do
    use GenServer

    # ------- Client API
    def start_link do
      GenServer.start_link(__MODULE__, :ok, [])
    end

    def start do
      GenServer.start(__MODULE__, :ok, [])
    end

    def titles(url) do
      ref = make_ref
      send :scraper, {self, ref, url}
      receive do
        {^ref, titles} -> {:ok, titles}
      after
        3_000 -> {:error, :timeout}
      end
    end

    def init(:ok) do
      {:ok, []}
    end

    def handle_call({:fetch_titles, url}, _from, state) do
       {:reply, _fetch_titles(url), state}
    end

    # ------- Private
    defp _fetch_titles(url) do
      url
      |> HTTPoison.get!
      |> parse_headers
    end

    defp parse_headers(%HTTPoison.Response{status_code: 200, body: body}) do
      Enum.flat_map ["h1", "h2", "h3"], fn selector ->
        body
        |> Floki.find(selector)
        |> Enum.map(&element_text/1)
      end
    end

    defp element_text({_tag, _attributes, [text]}) do
      text
    end

end
