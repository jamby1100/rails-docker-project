require "rails_helper"

RSpec.describe Post do
  describe "Add a post and it should be able to associate to an author" do
    let (:author) { FactoryBot.create(:author) }
    let (:post) { FactoryBot.create(:post, author: author) }

    it "should perfectly align with expectation" do
      expect(post.author).to eq(author)
    end
  end
end