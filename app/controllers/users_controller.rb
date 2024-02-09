class UsersController < ApplicationController
  before_action :authenticate_admin!

  # GET /users or /users.json
  def index
    @users = User.all.order(created_at: :desc)
  end

  # GET /users/1 or /users/1.json
  def show
    session[:user_id] = params[:id]
    redirect_to users_path
  end

end
