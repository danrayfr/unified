require 'pry'

class CoachingsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_membership
  before_action :set_coaching, only: %i[show edit update destroy acknowledgement]
  before_action :set_account, only: %i[show new create edit update destroy acknowledgement]
  before_action :mark_notifications_as_read, only: :show
  before_action :coachee, only: %i[acknowledgement]
  before_action :coach, only: %i[new create edit]
  before_action :admin?, only: :destroy

  def index
    filtered_coachings = filter_by_agent

    @coachings = if current_user.agent?
                   # @pagy, @coachings = pagy(Coaching.where(user: current_user).order(created_at: :desc))
                   filtered_coachings.where(user: current_user) # Coaching.where(user: current_user).order(created_at: :desc)
                 else
                   # @pagy, @coachings = pagy(Coaching.order(created_at: :desc))
                   filtered_coachings # Coaching.order(created_at: :desc)
                 end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    # mark_notifications_as_read(@coachings)
    @previous_coaching_log = Coaching.where('id < ?', @coaching.id).order(id: :desc).first
    respond_to do |format|
      format.html
      format.json { render json: @coaching.to_json(include: { note: { only: %i[id content] } }) }
      format.pdf do
        render pdf: 'hello-filename', template: 'coachings/coaching_pdf', formats: [:html], layout: 'pdf'
      end
    end
  end

  def new
    @note = Note.new
    @coaching = Coaching.new
    @coaching.build_note
  end

  def create
    @coaching = @account.coachings.build(coaching_params)

    @coaching.custom_note = populate_customs

    if @coaching.save
      redirect_to account_coaching_path(@account, @coaching), notice: 'Successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @note_content = @coaching.note.content if @coaching.note
    @note = @coaching.note

    @custom_note = @coaching.custom_note
  end

  def acknowledgement
    @coaching = Coaching.find(params[:id])
    @note = @coaching.note

    @custom_note = @coaching.custom_note
  end

  def update
    @coaching = Coaching.find(params[:id])
    @note = @coaching.note

    @custom_note = @coaching.custom_note

    # @coaching.custom_note = populate_customs

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
                                     :date_acknowledged, :user_id, :account_id, :coaching_title,
                                     :manager, :coach, :review_frequency, :review_instance,
                                     custom_note: [], note_attributes: %i[id content])
  end

  def check_role
    return if current_user.validate_coaching_access

    redirect_back(fallback_location: root_path, alert: "You're not authorized.")
  end

  def coach
    @account = Account.find(params[:account_id])

    return if current_user.manager?

    redirect_to account_coachings_url(@account), alert: "You're not allowed create or edit a coaching form."
  end

  def coachee
    @account = Account.find(params[:account_id])

    return if current_user.agent? && @coaching.user == current_user

    redirect_url = @ticket ? account_coaching_url(@account, @coaching) : account_coachings_url(@account)
    redirect_to redirect_url, alert: "You're not allowed to acknowledge this coaching record."
  end

  def mark_notifications_as_read
    notification_to_mark_as_read = @coaching.notifications_as_coaching.where(recipient: current_user)
    notification_to_mark_as_read.update_all(read_at: Time.zone.now) if current_user
  end

  def filter_by_agent
    email = params[:filter_by]

    user = User.find_by(email:)

    return Coaching.all if email == 'all' || email.blank?

    Coaching.where(user:)
  end

  def populate_customs
    customs = []
    params[:custom_name]&.each_with_index do |custom_name, index|
      content = params[:custom_content][index]
      custom = { custom_name:, content: }
      customs << custom
    end

    customs
  end
end
