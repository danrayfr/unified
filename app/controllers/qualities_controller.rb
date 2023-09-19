class QualitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_quality, only: %i[show edit update destroy acknowledgement]
  before_action :set_account
  # before_action :find_ticket, only: %i[show new create edit update destroy acknowledgement]
  before_action :mark_notifications_as_read, only: :show
  before_action :authenticate_edit_access, only: %i[new edit]
  before_action :agent, only: :acknowledgement

  def index
    filtered_qualities = filter

    @qualities = if current_user.agent?
                   filtered_qualities.where(user: current_user)
                 else
                   filtered_qualities
                 end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @quality.to_json(include: { note: { only: %i[id content] } }) }
      format.pdf do
        render pdf: 'hello-filename', template: 'qualities/quality_pdf', formats: [:html], layout: 'pdf'
      end
    end
  end

  def new
    @note = Note.new
    @quality = Quality.new
    @quality.build_note
  end

  def create
    @quality = @account.qualities.build(quality_params)

    @quality.metrics = populate_metrics

    if @quality.save
      redirect_to account_quality_path(@account, @quality), notice: 'QA saved'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @note_content = @quality.note.content if @quality.note
    @note = @quality.note
  end

  def acknowledgement
    # @quality = @ticket.quality
    @note_content = @quality.note.content if @quality.note
    @note = @quality.note
  end

  def update
    if @quality.update(quality_params)
      @quality.update(date_acknowledged: Time.now) if @quality.acknowledgement && @quality.date_acknowledged.nil?
      redirect_to account_quality_path(@account, @quality), notice: 'QA saved'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    return flash[:alert] = "You're not authorized to destroy record." unless current_user.admin?

    @quality.destroy
    redirect_to account_ticket_path(@account, @quality),
                alert: "You're not allowed to edit this QA record."
  end

  private

  def set_quality
    @quality = Quality.find(params[:id])
  end

  # def find_account
  #   @account = Account.find(params[:account_id])
  # end

  def quality_params
    params.require(:quality).permit(:rating, :acknowledgement, :date_acknowledged,
                                    :ticket_id, :account_id, :user_id, :link,
                                    metrics: [], note_attributes: %i[id content])
  end

  def check_if_qa_exist
    return if @ticket.quality.present?

    redirect_back(fallback_location: account_ticket_path(@account, @ticket),
                  alert: 'No QA Check yet.')
  end

  def authenticate_edit_access
    @account = Account.find(params[:account_id])

    return if current_user.qa? || current_user.manager?

    redirect_to account_qualities_path(@account),
                alert: "You're not allowed to create or update a QA record."
  end

  def agent
    @account = Account.find(params[:account_id])

    return if current_user.agent? && @quality.user == current_user

    redirect_to account_quality_path(@account, @quality),
                alert: "You're not suppose to acknowledge this QA record."
  end

  def populate_metrics
    metrics = []
    params[:metric_name]&.each_with_index do |metric_name, index|
      deduction = params[:deduction][index]
      content = params[:content][index]
      metric = { metric_name:, deduction:, content: }
      metrics << metric
    end

    metrics
  end

  def filter
    agent = params[:filter_by]

    Quality.filter_by_agent_email(agent)
  end

  def mark_notifications_as_read
    notification_to_mark_as_read = @quality.notifications_as_quality.where(recipient: current_user)
    notification_to_mark_as_read.update_all(read_at: Time.zone.now) if current_user
  end
end
