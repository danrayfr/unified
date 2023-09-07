# To deliver this notification:
#
# QualityNotification.with(post: @post).deliver_later(current_user)
# QualityNotification.with(post: @post).deliver(current_user)

class QualityNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  # param :post

  # Define helper methods to make rendering easier.
  #
  def message
    @quality = Quality.find(params[:quality][:id])
    "QA Audit Log #{@quality.id} with a rating of #{@quality.rating}% have been assigned to you."
  end

  def url
    quality = Quality.find(params[:quality][:id])
    account_ticket_qa_path(quality.ticket.account_id, quality.ticket_id, quality.id, subdomain: 'internal')
  end
end
