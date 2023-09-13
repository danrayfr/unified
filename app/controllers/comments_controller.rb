class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account

  def create
    @comment = @commentable.comments.new(comment_params.merge(user: current_user))
    @comment.save
    redirect_to account_coaching_url(@account, @commentable), notice: 'successfully posted!'
  end

  def destroy
    @comment = @commentable.comments.find(params[:id])
    redirect_back(fallback_location: account_ticket_path(@account, @commentable), notice: 'deleted') if @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:pinned, :user_id, :commentable_id, :commentable_type,
                                    note_attributes: %i[id content])
  end
end
