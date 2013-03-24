class CommentVotesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def create
    comment = Comment.find(params[:comment_id])
    if comment.vote(params[:direction], current_user)
      render text: render_to_string(partial: 'comments/comment',
                                    locals: { comment: comment })
    else
      render :json => {}, :status => 422
    end
  end
end
