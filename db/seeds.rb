# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

author = Author.create(name: "Raphael Jambalos", kind: "Programmer")
post = Post.create(title: "Redis", body: "This is a in-memory database often used for caching.", author_id: author.id)
post = Post.create(title: "PostgreSQL", body: "This is a transactional database used for transactions", author_id: author.id)
post = Post.create(title: "DynamoDB", body: "This is a NoSQL database used for concurrent workloads.", author_id: author.id)