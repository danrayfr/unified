class CoachingMailer < ApplicationMailer
  append_view_path Rails.root.join('app', 'views', 'mailers')

  def coaching_notification
    @coaching = params[:coaching]
    @user = params[:recipient]

    pdf = WickedPdf.new.pdf_from_string(
      render_to_string('coachings/coaching_pdf', layout: 'layouts/pdf')
    )
    attachments["#{@coaching.coaching_title}.pdf"] = pdf

    mail(
      to: params[:recipient].email,
      subject: "[Ninjafied] You have been assigned to a Coaching Log##{@coaching.coaching_title}."
    )
  end
end
