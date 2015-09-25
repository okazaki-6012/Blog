class Tag < ActiveRecord::Base
  has_many :blog_tag
  has_many :blog, through: :blog_tag
end
