module Qualities
  class CommentsController < CommentsController
    before_action :set_commentable

    private

    def set_commentable
      @commentable = Quality.find(params[:quality_id])
    end
  end
end
