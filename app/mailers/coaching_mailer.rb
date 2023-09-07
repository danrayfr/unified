class CoachingMailer < ApplicationMailer
  append_view_path Rails.root.join('app', 'views', 'mailers')

  def coaching_notification
    @coaching = params[:coaching]
    @user = params[:recipient]

    mail(
      to: params[:recipient].email,
      subject: "[Ninjafied] You have been assigned to a Coaching Log##{@coaching.id}."
    )
  end
end
