class ApplicationController < ActionController::API

  def authenticate_user!
    @current_user = User.new.auth_by_token(params['token'])
    render json: {errors: {error: ['Un_authorized action']}},status: :unauthorized unless @current_user.present?
  end


end
