json.array!(@local_government_areas) do |local_government_area|
  json.extract! local_government_area, :name
  json.url local_government_area_url(local_government_area, format: :json)
end
