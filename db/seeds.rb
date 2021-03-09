3.times do |n|
  category = Category.new(
    name: "カテゴリー#{n}"
  )

  5.times do |i|
    category.ideas.build(
      body: "本文#{i}"
    )
  end

  category.save

end