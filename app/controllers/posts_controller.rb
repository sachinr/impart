class PostsController < ApplicationController
  inherit_resources
  before_filter :authenticate_user!, :only => ['new', 'create', 'edit', 'update']

  def index
    @posts = Post.order('created_at DESC').all
  end

  def latest
    @posts = Post.order('created_at DESC').all
    render 'index'
  end
end
