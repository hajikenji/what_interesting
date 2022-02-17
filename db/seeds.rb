5.times do |_n|
  name = "aaab" + rand(10..200).to_s
  email = Faker::Internet.email
  password = 'password'
  User.create!(name: name,
               email: email,
               password: password)
end

# 5.times do |_n|
#   title = 'aaaa' + rand(1..10).to_s
#   link = Faker::Internet.email
#   Article.create!(title: title,
#                   link: link
#                 )
# end

num = 0
5.times do |_n|
  content = 'aaaa' + rand(1..10).to_s
  article_id = Article.first.id
  user_id = User.first(5)
  Comment.create!(content: content,
                  article_id: article_id,
                  user_id: user_id[num].id
                )
  num += 1
end
