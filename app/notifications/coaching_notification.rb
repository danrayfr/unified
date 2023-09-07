# To deliver this notification:
#
# CoachingNotification.with(post: @post).deliver_later(current_user)
# CoachingNotification.with(post: @post).deliver(current_user)

class CoachingNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  deliver_by :email, mailer: 'CoachingMailer', delay: 1.hours, unless: :read?
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  # param :post

  # Define helper methods to make rendering easier.
  #
  def message
    @coaching = Coaching.find(params[:coaching][:id])
    "Coaching Log #{@coaching.id} have been assigned to you."
  end

  def url
    coaching = Coaching.find(params[:coaching][:id])
    account_coaching_path(coaching.account_id, coaching.id, subdomain: 'internal')
  end
end
