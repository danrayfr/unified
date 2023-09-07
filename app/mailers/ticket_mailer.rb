class TicketMailer < ApplicationMailer
  def ticket_notification
    @ticket = params[:ticket]
    @user = params[:recipient]
    mail(
      to: params[:recipient].email,
      subject: "[Ninjafied] You have been assigned to a ticket review ##{@ticket.id}."
    )
  end
end
