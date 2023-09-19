class QualityMailer < ApplicationMailer
  append_view_path Rails.root.join('app', 'views', 'mailers')

  def quality_notification
    @quality = params[:quality]
    @user = @quality.user

    pdf = WickedPdf.new.pdf_from_string(
      render_to_string('qualities/quality_pdf', layout: 'layouts/pdf')
    )
    attachments["QA Audit#{@quality.id}.pdf"] = pdf

    mail(
      to: @user.email,
      subject: "[Ninjafied] You have been assigned to a QA Audit Log# #{@quality.id}."
    )
  end
end
