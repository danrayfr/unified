class ScheduleMailer < ApplicationMailer
  append_view_path Rails.root.join('app', 'views', 'mailers')

  def schedule_notification
    @schedule = params[:schedule]
    participant_emails = @schedule.participants.where.not(email: @schedule.user.email).pluck(:email)
    # participant_emails = @schedule.participants.pluck(:email)

    mail(
      to: participant_emails,
      cc: @schedule.user.email,
      subject: "You have been invited to a #{@schedule.category} schedule with a title of #{@schedule.title}."
    )
  end
end
