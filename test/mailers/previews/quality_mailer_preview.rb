# Preview all emails at http://localhost:3000/rails/mailers/quality_mailer
class QualityMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/quality_mailer/qa_notification
  def qa_notification
    QualityMailer.qa_notification
  end
end
