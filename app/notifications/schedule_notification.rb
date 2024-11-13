# To deliver this notification:
#
# ScheduleNotification.with(post: @post).deliver_later(current_user)
# ScheduleNotification.with(post: @post).deliver(current_user)

class ScheduleNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  deliver_by :email, mailer: 'ScheduleMailer'
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  # param :post

  # Define helper methods to make rendering easier.

  def message
    @schedule = Schedule.find(params[:schedule][:id])
    "You have been invited to a #{@schedule.category} schedule."
  end

  def url
    # schedule = Schedule.find(params[:schedule][:id])
    schedules_path
  end
end
