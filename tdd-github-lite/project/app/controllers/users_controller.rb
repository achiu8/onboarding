class UsersController < ApplicationController
  def show
    @user = User.find(params[:username])
    @authenticated_user = User.current
    @repos = @user.repos.sort_by(&:watchers_count).reverse
    @activities = @user.activities
    render 'show'
  end
end
