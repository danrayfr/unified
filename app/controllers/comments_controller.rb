class CommentsController < ApplicationController
  before_action :authenticate_user!
  # before_action :authenticate_membership
  before_action :set_coaching
  before_action :set_account

  # rubocop:disable Metrics/AbcSize
  def create
    # @coaching = Coaching.find(params[:ticket_id])
    @comment = @coaching.comments.build(comment_params.merge(user: current_user))

    # @account = Account.find(params[:account_id])

    if @comment.save
      @comment.build_note
      # redirect_to account_ticket_path(@account, @ticket), notice: 'created'
    else
      # redirect_to account_ticket_path(@account, @ticket), alert: 'not created'
    end
  end
  # rubocop:enable Metrics/AbcSize

  def destroy
    @comment = @ticket.comments.find(params[:id])
    redirect_back(fallback_location: account_ticket_path(@account, @ticket), notice: 'deleted') if @comment.destroy
  end

  private

  def set_coaching
    @coaching = Coaching.find(params[:coaching_id])
  end

  def set_account
    @account = Account.find(params[:account_id])
  end

  def comment_params
    params.require(:comment).permit(:pinned, :ticket_id, :user_id, note_attributes: %i[id content])
  end
end
