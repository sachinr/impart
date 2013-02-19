class CommentsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def create
    comment = Comment.new(params[:comment])

    if comment.save!
      render :json => comment.to_json
    else
      render :json => { :errors => comment.errors.full_messages }, :status => 422
    end
  end
end
