class QualityMailer < ApplicationMailer
  append_view_path Rails.root.join('app', 'views', 'mailers')

  def quality_notification
    @qa = params[:quality]
    @user = @qa.ticket.user

    mail(
      to: @user.email,
      subject: "[Ninjafied] You have been assigned to a QA Audit Log##{@qa.id}."
    )
  end
end
