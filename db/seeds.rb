# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

author = Author.create(name: "De Angelo", kind: "C-Class")
post = Post.create(title: "The sistine chapel", body: "Is the most amazing thing ever", author_id: author.id)
post = Post.create(title: "Pastel and Colors", body: "Are a wonderwall", author_id: author.id)
post = Post.create(title: "Passionate Oils", body: "For painting", author_id: author.id)

