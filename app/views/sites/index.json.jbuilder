json.array!(@sites) do |site|
  json.extract! site, :id, :name, :description, :address, :suburb, :latitude, :longitude, :size, :water, :available_until, :status
  json.url site_url(site, format: :json)
  json.display_name site.to_s
end
