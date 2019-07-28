class IncrementCountWorker
  include Sidekiq::Worker

  def perform(post_id)
    post = Post.find(post_id)

    post.likes_count ||= 0
    post.likes_count += 1
    post.save
  end
end
