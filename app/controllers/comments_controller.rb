class CommentsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def create
    comment = Comment.new(params[:comment])
    comment.user = current_user
    if comment.save!
      if comment.commentable_type == 'Post'
        UserMailer.comment_notification_email(comment).deliver
      end
      render :create, layout: false, locals: {comment: comment}
    else
      render json: { errors: comment.errors.full_messages }, status: 422
    end
  end

  def destroy
    comment = current_user.comments.find_by_id(params[:id])
    comment = Comment.find(params[:id]) if comment.nil? && current_user.admin?
    if comment.remove_comment_from_thread
      render nothing: true, status: 200
    end
  end
end
