# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Sejfguru.Repo.insert!(%Sejfguru.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Sejfguru.{Repo, Asset}

Repo.insert!(%Asset{
  asset_type: 'phone',
  name: "iPhone 5s",
  brand: "Apple",
  model: "iPhone 5s",
  os: "iOS",
  os_version: "10.2"
})

Repo.insert!(%Asset{
  asset_type: 'phone',
  name: "Google Pixel",
  brand: "Google",
  model: "Pixel",
  os: "Android",
  os_version: "7.1"
})
