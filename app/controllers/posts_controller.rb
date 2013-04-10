class PostsController < ApplicationController
  inherit_resources
  before_filter :authenticate_user!, :only => ['new', 'create', 'edit', 'update']

  def index
    @title = 'Hot Posts'
    @posts = Post.all_with_user_votes(current_user)
    render 'index', layout: 'landing'
  end

  def latest
    @title = 'Latest Posts'
    @posts = Post.latest_with_user_votes(current_user)
    render 'index', layout: 'landing'
  end

  def top
    @title = 'Top Posts'
    @posts = Post.top_with_user_votes(current_user, params[:period])
    render 'index', layout: 'landing'
  end

  def create
    @post = current_user.posts.new(params[:post])
    if @post.save!
      flash[:notice] = 'Successfully created post'
      redirect_to post_path(@post)
    end
  end

  def show
    @post = Post.find_with_user_vote(params[:id], current_user)
    @comment = Comment.new(commentable_type: 'Post', commentable_id: @post.id)
    @comments = @post.comments.sort_by_rank
    @user = current_user
    render :show
  end

  def description
    @post = Post.find_with_user_vote(params[:id], current_user)
    render text: render_to_string(partial: 'posts/description',
                                  locals: {post: @post})
  end
end
