# app/controllers/searches_controller.rb

class SearchesController < ApplicationController
  def show
    if params[:query].present?
      @accounts = current_user.accounts.where("name like ?", "%#{params[:query]}%").limit(5)
    else
      @accounts = current_user.accounts.limit(5)
    end
  end
end
