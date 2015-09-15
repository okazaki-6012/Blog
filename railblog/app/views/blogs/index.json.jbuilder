json.array!(@blogs) do |blog|
  json.extract! blog, :id, :title, :word, :dating
  json.url blog_url(blog, format: :json)
end
