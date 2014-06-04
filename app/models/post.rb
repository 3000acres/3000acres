class Post < ActiveRecord::Base

  belongs_to :site
  belongs_to :user

  default_scope { order("created_at DESC") }

end
