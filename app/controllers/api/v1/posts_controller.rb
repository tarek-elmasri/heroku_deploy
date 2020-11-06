class Api::V1::PostsController < ApplicationController
  before_action :authenticate_user! , except: [:index,:show]
  before_action :get_post , only: [:show , :destroy , :update]
  
  def index
    posts = Post.order('created_at DESC')
    render json: {posts: posts}
  end

  def show 
    if @post
      render json: {post: @post},status: :ok
    else
      render json: {errors: {post: ['Post not found']}},status: :unprocessable_entity
    end
  end

  def create
    post=@current_user.posts.create(posts_params)
    if post.save
      render json:{post: post},status: :created 
    else
      render json:{errors: post.errors},status: :unprocessable_entity
    end
  end

  def destroy
    if @post&.accessable_by?(@current_user)
      if @post.delete
        render json: {msg: 'post deleted successfully'},status: :ok
      else
        render json: {errors: @post.errors},status: :unprocessable_entity
      end
    else
      render json: {errors: {error: ['unauthorized action']}},status: :unauthorized
    end
  end

  def update
    if @post&.accessable_by?(@current_user)
      if @post.update(posts_params)
        render json: {post: @post},status: :ok
      else
        render json: {errors: @post.errors},status: :unprocessable_entity
      end
    else
      render json: { errors:{error: ['unauthorized action']}}
    end
  end


  private
  def posts_params
    params.permit(:title , :body)
  end

  def get_post 
    @post=Post.find_by(id: params[:id])
  end
end
