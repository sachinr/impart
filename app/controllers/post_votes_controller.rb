class PostVotesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def create
    post = Post.find(params[:post_id])
    if post.upvote(current_user)
      render :json => post.votes.to_json
    else
      render :json => {}, :status => 422
    end
  end
end
