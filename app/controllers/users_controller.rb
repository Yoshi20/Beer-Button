class UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_user, only: [:destroy]
  before_action { @section = 'users' }

  # GET /users or /users.json
  def index
    @users = User.all.order(created_at: :desc)
  end

  # GET /users/1 or /users/1.json
  def show
    session[:user_id] = params[:id]
    redirect_to users_path
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if current_user.admin? || current_user == @user
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_path, notice: t('flash.notice.deleting_user') }
        format.json { head :no_content }
      end
    else
      raise 'impossibru!'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

end
