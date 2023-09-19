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
    filtered_coachings = filter

    @coaching_compliance = coaching_compliance

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
                                     :agent_count_per_week, custom_note: [], note_attributes: %i[id content])
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

  def filter
    agent = params[:filter_by]

    Coaching.filter_by_agent_email(agent)
  end

  # def filter_by_agent
  #   email = params[:filter_by]

  #  user = User.find_by(email:)

  #  return Coaching.all if email == 'all' || email.blank?

  #  Coaching.where(user:)
  # end

  def populate_customs
    customs = []
    params[:custom_name]&.each_with_index do |custom_name, index|
      content = params[:custom_content][index]
      custom = { custom_name:, content: }
      customs << custom
    end

    customs
  end

  def coaching_compliance
    # Fetch the coaching data
    coaching_data = Coaching.pluck(:coaching_start_date, :acknowledgement, :user_id, :agent_count_per_week)

    # Initialize a hash to group the data by week
    grouped_data = coaching_data.group_by do |coaching|
      coaching_start_date = coaching[0]
      coaching_start_date.beginning_of_week.strftime('%m-%d-%Y - Week %U')
    end

    # Initialize the result hash
    result_hash = {}

    # Process grouped data
    grouped_data.each do |week_start_date, coaching_data|
      total_acknowledge = coaching_data.count { |data| data[1] == true }
      total_account_users = coaching_data.map { |data| data[2] }.uniq.count
      agent_count_per_week = coaching_data.sum { |data| data[3] }

      average_agent_count_per_week = agent_count_per_week / total_account_users

      result_hash[week_start_date] = {
        value: coaching_data.size,
        total_acknowledge:,
        agent_count_per_week: average_agent_count_per_week
      }
    end

    result_hash
  end
end
