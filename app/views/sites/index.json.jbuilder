json.array!(@sites) do |site|
  json.extract! site, :id, :slug, :name, :description, :address, :suburb, :latitude, :longitude, :size, :water, :available_until, :status, :watches
  json.image(site.image.file? ? site.image.url(:small) : "")
  json.url site_url(site, format: :json)
  json.display_name site.to_s
end
