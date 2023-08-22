require 'pry'

class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ticket, only: %i[show edit update destroy]
  before_action :set_account, only: %i[create]
  before_action :authenticate_membership
  before_action :check_role, only: %i[new edit destroy]

  def index
    @tickets = Ticket.order(created_at: :desc)
  end

  def show; end

  def new
    @ticket = Ticket.new
    @account = Account.find(params[:account_id])
    @ticket.ticket_details.build
  end

  def create
    @ticket = @account.tickets.build(ticket_params.merge(user_id: current_user.id))

    if @ticket.save
      create_ticket_details
      redirect_to account_ticket_path(@account, @ticket), notice: 'Ticket successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @account = Account.find(params[:account_id])
  end

  def update
    @account = Account.find(params[:account_id])

    if @ticket.update(ticket_params)
      redirect_to account_ticket_path(@account, @ticket), notice: 'Ticket successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    redirect_to account_tickets_url, notice: 'Ticket successfully deleted.' if @ticket.destroy
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def set_account
    @account = Account.find(params[:account_id])
  end

  def ticket_params
    params.require(:ticket).permit(:link, :assignee, :user_id, :account_id,
                                   ticket_details_attributes: %i[id content access_level ticket_id _destroy])
  end

  def authenticate_membership
    @account = Account.find(params[:account_id])

    return if @account.users.include?(current_user)

    redirect_to account_url(@account),
                alert: "You're not authorized to access tickets in the account."
  end

  def check_role
    @account = Account.find(params[:account_id])

    return if current_user.validate

    redirect_to account_url(@account),
                alert: "You're not allowed to that!"
  end
end
