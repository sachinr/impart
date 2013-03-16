class CommentsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def create
    comment = Comment.new(params[:comment])
    comment.user = current_user
    if comment.save!
      render(partial: "comment", layout: false, locals: {comment: comment})
    else
      render json: { errors: comment.errors.full_messages }, status: 422
    end
  end

  def destroy
    comment = current_user.comments.find_by_id(params[:id])
    comment = Comment.find(params[:id]) if comment.nil? && current_user.admin?
    if comment.delete!
      render(partial: 'deleted_comment', layout: false, locals: {comment: comment})
    end
  end
end
