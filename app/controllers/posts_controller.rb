class PostsController < ApplicationController
  inherit_resources
  before_filter :authenticate_user!, :only => ['new', 'create', 'edit', 'update']

  def index
    @posts = Post.sort_by_rank
  end

  def latest
    @posts = Post.order('created_at DESC').all
    render 'index'
  end

  def create
    @post = current_user.posts.new(params[:post])
    if @post.save!
      flash[:notice] = 'Successfully created post'
      redirect_to post_path(@post)
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new(commentable_type: 'Post', commentable_id: @post.id)
    @comments = @post.comments.sort_by_score
  end
end
