defmodule Sejfguru.ReleaseTasks do
  @moduledoc """
    List of functions that are run before release, such as migrations.
  """

  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto
  ]

  @myapps [
    :sejfguru
  ]

  @repos [
    Sejfguru.Repo
  ]

  def migrate do
    IO.puts "Loading Sejfguru..."
    :ok = Application.load(:sejfguru)

    IO.puts "Starting dependencies..."
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    IO.puts "Starting repos..."
    Enum.each(@repos, &(&1.start_link(pool_size: 1)))

    Enum.each(@myapps, &run_migrations_for/1)

    IO.puts "Success!"
    :init.stop()
  end

  defp priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp run_migrations_for(app) do
    IO.puts "Running migrations for #{app}"
    Ecto.Migrator.run(Sejfguru.Repo, migrations_path(app), :up, all: true)
  end

  defp migrations_path(app), do: Path.join([priv_dir(app), "repo", "migrations"])
end
