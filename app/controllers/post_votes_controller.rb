class PostVotesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def create
    post = Post.find(params[:post_id])
    post_vote = PostVote.new(user_id: current_user.id, post_id: post.id)
    if post_vote.save
      render :json => post.votes.to_json
    else
      render :json => { :errors => post_vote.errors.full_messages }, :status => 422
    end
  end

  def destroy
  end
end
