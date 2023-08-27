require 'pry'

class CoachingsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_membership
  before_action :set_coaching, only: %i[show edit update destroy acknowledgement]
  before_action :set_account, only: %i[show new create edit update destroy acknowledgement]
  before_action :mentee, only: %i[acknowledgement]
  before_action :mentor, only: %i[new create edit]
  before_action :admin?, only: :destroy

  def index
    # @coachings = Coaching.all
    @pagy, @coachings = pagy(Coaching.order(created_at: :desc))
  end

  def show; end

  def new
    @note = Note.new
    @coaching = Coaching.new
    @coaching.build_note
  end

  def create
    @coaching = @account.coachings.build(coaching_params)

    if @coaching.save
      redirect_to account_coaching_path(@account, @coaching), notice: 'Successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @note_content = @coaching.note.content if @coaching.note
    @note = @coaching.note
  end

  def acknowledgement
    @coaching = Coaching.find(params[:id])
    @note = @coaching.note
  end

  def update
    @coaching = Coaching.find(params[:id])
    @note = @coaching.note

    if @coaching.update(coaching_params)

      @coaching.update(date_acknowledged: Time.now) if @coaching.acknowledgement && @coaching.date_acknowledged.nil?

      redirect_to account_coaching_path(@account, @coaching), notice: 'Coaching successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @coaching.destroy
    redirect_to account_coachings_path, notice: 'Successfully deleted.'
  end

  private

  def set_coaching
    @coaching = Coaching.find(params[:id])
  end

  def coaching_params
    params.require(:coaching).permit(:coaching_start_date, :coaching_end_date, :acknowledgement,
                                     :date_acknowledged, :user_id, :account_id,
                                     note_attributes: %i[id content])
  end

  def check_role
    return if current_user.validate_coaching_access

    redirect_back(fallback_location: root_path, alert: "You're not authorized.")
  end

  def mentor
    @account = Account.find(params[:account_id])

    return if current_user.manager?

    redirect_to account_coachings_url(@account), alert: "You're not allowed create or edit a coaching form."
  end

  def mentee
    @account = Account.find(params[:account_id])

    return if current_user.agent? && @coaching.user == current_user

    redirect_url = @ticket ? account_coaching_url(@account, @coaching) : account_coachings_url(@account)
    redirect_to redirect_url, alert: "You're not allowed to acknowledge this coaching record."
  end
end
