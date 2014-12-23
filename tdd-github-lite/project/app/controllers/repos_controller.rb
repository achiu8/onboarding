class ReposController < ApplicationController
  def show
    @repo = Repo.new(params[:username], params[:reponame])
    @user = User.find(params[:username])
    render 'show'
  end

  def create
    respond_to do |format|
      format.html { redirect_to "/users/#{User.current}" }
      format.js {}
    end
  end

  def submit
    res = Util.post("/user/repos", { "name" => repo_params["reponame"] })
    @repo = Repo.new(res["owner"]["login"], res["name"])

    render json: @repo
  end

  private

  def repo_params
    params.require(:repo).permit(:username, :reponame)
  end
end
