class ProfilesController < ApplicationController

  def show
    @user = User.find_by_username(params[:username])
    @posts = Post.latest_from_user(current_user, @user)

    if @user
      @posts = @posts.paginate(page: params[:page], per_page: Post.per_page)

      render 'show'
    else
      flash[:error] = 'User not found'
      redirect_to posts_path
    end
  end
end
