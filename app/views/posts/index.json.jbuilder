json.array!(@posts) do |post|
  json.extract! post, :subject, :body, :user_id
  json.url post_url(post, format: :json)
end
