class Api::V1::PostsController < Api::V1::BaseController
  before_action :set_post, only: [:edit, :update, :destroy]

  def index
    @posts = Post.all
    render json: @posts.to_json
  end

  def create
    if @post = Post.create(post_params)
      render json: @post.to_json, status: :ok
    else
      render json: @post.errors.full_messages.join(', '), status: :bad_request
    end
  end

  def update
    if @post.update(post_params)
      render json: @post.to_json, status: :ok
    else
      render json: @post.errors.full_messages.join(', '), status: :bad_request
    end
  end

  def destroy
    @post.destroy
    render json: {}, status: :ok
  end

  protected
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :username)
  end
end
