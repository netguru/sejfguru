defmodule Sejfguru.Assets.PeriodicalAssetImporter do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work(minutes: 1)
    {:ok, state}
  end

  def handle_info(:work, state) do
    work(Application.get_env(:sejfguru, :env))
    schedule_work(hours: 24)
    {:noreply, state}
  end

  defp schedule_work(minutes: minutes), do: Process.send_after(self(), :work, minutes * 60 * 1000)
  defp schedule_work(hours: hours), do: Process.send_after(self(), :work, hours * 60 * 60 * 1000)

  defp work(:dev), do: nil
  defp work(:test), do: nil

  defp work(_) do
    {_, info} = Sejfguru.Assets.AssetImporter.import
    IO.puts("[#{DateTime.utc_now}] #{info}")
  end
end
