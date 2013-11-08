json.array!(@sites) do |site|
  json.extract! site, :name, :description, :address, :suburb, :latitude, :longitude, :size, :water, :available_until, :status
  json.url site_url(site, format: :json)
end
