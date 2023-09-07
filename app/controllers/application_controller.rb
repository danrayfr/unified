# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :set_notifications, if: :current_user

  def set_account
    @account = Account.find(params[:account_id])
  end

  def authenticate_membership
    @account = Account.find(params[:account_id])

    return if @account.users.include?(current_user)

    redirect_to account_url(@account),
                alert: "You're not authorized to access tickets in the account."
  end

  private

  def set_notifications
    notifications = Notification.where(recipient: current_user).newest_first.limit(9)
    @unread = notifications.unread
    @read = notifications.read
  end

  protected

  # Confirms if the user is admin
  def admin?
    redirect_back(fallback_location: root_path, alert: "You're not authorized.") unless current_user.admin?
  end

  def agent?
    redirect_back(fallback_location: root_path, alert: "You're not authorized.") unless current_user.agent?
  end

  def manager?
    redirect_back(fallback_location: root_path, alert: "You're not authorized.") unless current_user.manager?
  end

  def qa?
    redirect_back(fallback_location: root_path, alert: "You're not authorized.") unless current_user.qa?
  end
end
