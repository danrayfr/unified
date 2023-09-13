module Tickets
  class CommentsController < CommentsController
    before_action :set_commentable

    private

    def set_commentable
      @commentable = Ticket.find(params[:id])
    end
  end
end
