class Blog < ActiveRecord::Base
  has_many :blog_tag
  has_many :tag, through: :blog_tag
end
