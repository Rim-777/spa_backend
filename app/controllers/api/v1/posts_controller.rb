class Api::V1::PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy]

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      render json: @post.to_json, status: :ok
    else
      render json: @post.errors.full_messages.join(', '), status: :bad_request
    end
  end

  def edit

  end

  def update

  end

  def destroy

  end


  protected
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :username)
  end
end
