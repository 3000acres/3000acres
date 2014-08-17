json.extract! @site, :id, :slug, :name, :description, :address, :suburb, :latitude, :longitude, :size, :water, :available_until, :status, :created_at, :updated_at, :watches
json.url site_url(@site, format: :json)
json.display_name @site.to_s
