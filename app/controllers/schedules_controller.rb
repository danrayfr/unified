require 'pry'

class SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_schedule, only: %i[show edit update destroy]

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
    params.require(:schedule).permit(:title, :category, :start_time, :end_time, :user_id, participant_ids: [])
  end
end
