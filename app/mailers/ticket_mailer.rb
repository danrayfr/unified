class TicketMailer < ApplicationMailer
  append_view_path Rails.root.join('app', 'views', 'mailers')

  def ticket_notification
    @ticket = params[:ticket]
    @user = params[:recipient]
    mail(
      to: params[:recipient].email,
      subject: "[Ninjafied] You have been assigned to a ticket review ##{@ticket.id}."
    )
  end
end
