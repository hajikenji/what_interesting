json.extract! article, :id, :title, :link, :icon, :ranking, :created_at, :updated_at
json.url article_url(article, format: :json)
