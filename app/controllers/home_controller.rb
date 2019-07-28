class HomeController < ApplicationController
  def index
    @message = "Dynamic"

    @posts = Post.all
  end
end
