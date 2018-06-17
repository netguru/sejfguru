defmodule Sejfguru.Assets.Location do
  def city_lables do
    Map.keys(locations().cities)
  end

  def other_labels do
    Map.keys(locations().other)
  end

  def all_locations_label do
    "Wszystkie miasta"
  end

  def locations do
    %{
      cities: %{
        "Białystok" => ["Białystok"],
        "Gdańsk" => ["Grunwaldzka 103A"],
        "Kraków" => ["Pawia 9", "Krakow Warehouse"],
        "Poznań" => ["Wojskowa 6", "Poznan Warehouse"],
        "Warszawa" => ["Jana Pawla II 29", "Warszawa Warehouse"],
        "Wrocław" => ["Wita Stwosza 15/9A"],
        "Zielona Góra" => ["Zielona Góra"],
      },
      other: %{
        "Pozostałe" => ["Remote"],
        all_locations_label() => :all_locations,
      }
    }
  end
end
