require 'pry'

class SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_schedule, only: %i[show edit update destroy]
  before_action :mark_notifications_as_read, only: :show
  before_action :restricted, only: %i[new edit destroy]

  def index
    @schedules = current_user.schedules.where(start_time: Time.now.beginning_of_month.beginning_of_week..Time.now.end_of_month.end_of_week)
  end

  def show; end

  def new
    @schedule = current_user.schedules.build
  end

  def create
    @schedule = current_user.schedules.build(schedule_params)

    if @schedule.save
      user = User.find_by(id: @schedule.user_id)
      @schedule.participants << user
      @schedule.participants << @participants.to_a
      redirect_to root_path, notice: 'New schedule successfully set on calendar.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @schedule.update(schedule_params)
      redirect_to root_path, notice: 'New schedule successfully edited on calendar.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    redirect_to root_path, notice: 'New schedule successfully edited on calendar.' if @schedule.destroy
  end

  private

  def set_schedule
    @schedule = Schedule.find(params[:id])
  end

  def schedule_params
    params.require(:schedule).permit(:title, :category, :start_time, :end_time, :link, :user_id, participant_ids: [])
  end

  def restricted
    return if current_user.operations? || current_user.admin? || current_user.manager?

    redirect_to schedules_url, alert: "You're not allowed to set a schedule."
  end

  def mark_notifications_as_read
    notification_to_mark_as_read = @schedule.notifications_as_schedule.where(recipient: @schedule.participants)
    notification_to_mark_as_read.update_all(read_at: Time.zone.now) if @schedule.participants
  end
end
