class Api::V1::SessionsController < ApplicationController

  def auth_by_token
    user=User.new.auth_by_token(params[:token])
    if user 
      render json: {user: user.data},status: :ok
    else
      render json: {errors: {token: ['invalid or expired token']}},status: :unauthorized
    end

  end

  def auth_by_email
    user=User.new.auth_by_email(params[:email] , params[:password])
    if user 
      render json: {user: user.data},status: :ok
    else
      render json: {errors: {user: ['Invalid E-mail address or  password']}},status: :unauthorized
    end
  end

  def create_new_user
    user= User.new(users_params)
    if user.save
      render json: {user: user.username , email: user.email}, status: :created
    else
      render json: {errors: user.errors}, status: :unprocessable_entity
    end
  end

  def get_user_by_id
    user=User.find_by(id: params[:id])
    if user 
      render json: {user: {username: user.username , email: user.email}},status: :ok
    else
      render json: {errors: {user: ['Invalid user id']}},status: :unprocessable_entity
    end
  end


  private

  def users_params
    params.permit(:username , :password , :password_confirmation,:email)
  end

end
