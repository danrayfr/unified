# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend

  protected

  # Confirms if the user is admin
  def admin?
    redirect_to root_url, notice: "You're not authorized." unless current_user.admin?
  end
end
