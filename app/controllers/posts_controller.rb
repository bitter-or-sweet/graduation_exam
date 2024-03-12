class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index]
  def index
    @posts = Post.all.includes(:user).order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: t('defaults.message.created', item: Post.model_name.human)
    else
      flash.now['alert'] = t('defaults.message.not_created', item: Post.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :alcohol, :appetizer, :body)
  end
end
