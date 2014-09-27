class CommentsController < ApplicationController
  before_action :set_image
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  def new
    @comment = Comment.new
  end

  def create
    @comment = @image.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      flash[:notice] = "You've commented on this image."
      redirect_to [@image]
    else
      flash[:error] = "Uh oh.. something went wrong."
    end
  end

  def edit
  end

  def update
    if @comment.save
      flash[:notice] = "Comment updated."
      redirect_to [@image]
    else
      flash[:error] = "Uh oh.. something went wrong."
      render :edit
    end
  end

  def destroy
    if @comment.destroy
      flash[:alert] = "Comment deleted."
    else
      flash[:error] = "Uh oh.. something went wrong."
    end
    
    redirect_to [@image]
  end

  private

    def set_image
      @image = Image.find(params[:image_id])
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      if @comment.nil?
        flash[:notice] = "You're not authorized to do this!"
        redirect_to root_path
      end
    end

    def comment_params
      params.require(:comment).permit(:body, :image_id)
    end
end
