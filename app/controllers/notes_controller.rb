class NotesController < ApplicationController
  before_action :set_notable

  def new
    @note = @notable.note.new
  end

  def create
    @note = @notable.note.new(note_params)
    @notable.save
  end

  def edit
    @note = @notable.note
  end

  def update
    @note.update(note_params)
  end

  private

  def set_notable
    @notable = Coaching.find(params[:coaching_id])
  end

  def note_params
    params.require(:note).permit(:content)
  end
end
