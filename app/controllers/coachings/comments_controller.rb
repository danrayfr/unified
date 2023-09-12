module Coachings
  class CommentsController < CommentsController
    before_action :set_commentable

    private

    def set_commentable
      @commentable = Coaching.find(params[:coaching_id])
    end
  end
end
