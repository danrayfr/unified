require 'pry'
class QualitiesController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_quality, only: %i[show update destroy]
  before_action :find_account, only: %i[show new create edit update destroy acknowledgement]
  before_action :find_ticket, only: %i[show new create edit update destroy acknowledgement]
  # before_action :mark_notifications_as_read, only: :show
  before_action :qa, only: %i[new edit]
  before_action :check_if_qa_exist, only: %i[show]
  before_action :mentee, only: :acknowledgement

  def show
    @quality = @ticket.quality
    mark_notifications_as_read
  end

  def new
    @note = Note.new
    @quality = @ticket.build_quality
    @quality.build_note
  end

  def create
    @quality = @ticket.build_quality(quality_params)

    if @quality.save
      redirect_to account_ticket_qa_path(@account, @ticket), notice: 'QA saved'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @quality = @ticket.quality
    @note_content = @quality.note.content if @quality.note
    @note = @quality.note
  end

  def acknowledgement
    @quality = @ticket.quality
    @note_content = @quality.note.content if @quality.note
    @note = @quality.note
  end

  def update
    @quality = @ticket.quality

    if @quality.update(quality_params)
      @quality.update(date_acknowledged: Time.now) if @quality.acknowledgement && @quality.date_acknowledged.nil?
      redirect_to account_ticket_qa_path(@account, @ticket), notice: 'QA saved'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    return flash[:alert] = "You're not authorized to destroy record." unless current_user.admin?

    @quality.destroy
    redirect_to account_ticket_path(@account, @ticket),
                alert: "You're not allowed to edit this QA record."
  end

  private

  def set_quality
    @quality = Quality.find(params[:id])
  end

  def find_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end

  def find_account
    @account = Account.find(params[:account_id])
  end

  def quality_params
    params.require(:quality).permit(:rating, :acknowledgement, :date_acknowledged, :ticket_id,
                                    note_attributes: %i[id content])
  end

  def check_if_qa_exist
    return if @ticket.quality.present?

    redirect_back(fallback_location: account_ticket_path(@account, @ticket),
                  alert: 'No QA Check yet.')
  end

  def qa
    @account = Account.find(params[:account_id])

    return if current_user.qa? || current_user.admin?

    redirect_to account_ticket_qa_path(@account, @ticket),
                alert: "You're not allowed to create or update a QA record."
  end

  def mentee
    @account = Account.find(params[:account_id])

    return if current_user.agent? && @ticket.user == current_user

    redirect_to account_ticket_qa_path(@account, @ticket),
                alert: "You're not suppose to acknowledge this QA record."
  end

  def mark_notifications_as_read
    notification_to_mark_as_read = @quality.notifications_as_quality.where(recipient: current_user)
    notification_to_mark_as_read.update_all(read_at: Time.zone.now) if current_user
  end
end
