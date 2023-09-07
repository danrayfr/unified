# To deliver this notification:
#
# TicketNotification.with(post: @post).deliver_later(current_user)
# TicketNotification.with(post: @post).deliver(current_user)

class TicketNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  deliver_by :email, mailer: 'TicketMailer', delay: 1.minute, unless: :read?
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  # param :post

  # Define helper methods to make rendering easier.
  #
  def message
    @ticket = Ticket.find(params[:ticket][:id])
    "New ticket review has been assign to you: #{@ticket.link}"
  end

  def url
    ticket = Ticket.find(params[:ticket][:id])
    account_ticket_path(ticket.account_id, ticket.id, subdomain: 'internal')
  end
end
