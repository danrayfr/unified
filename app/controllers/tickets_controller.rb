class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ticket, only: %i[show edit update destroy]
  before_action :set_account, only: %i[index create]
  before_action :authenticate_membership
  before_action :check_role, only: %i[new create edit destroy]

  def index
    @tickets_total = @account.tickets
    @pagy, @tickets = pagy(@account.tickets.order(created_at: :desc))
  end

  def show; end

  def new
    @ticket = Ticket.new
    @account = Account.find(params[:account_id])
    @ticket.ticket_details.build
  end

  def create
    @ticket = @account.tickets.build(ticket_params.merge(modified_by: current_user.email))

    if @ticket.save
      # create_ticket_details
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

    if @ticket.update(ticket_params.merge(modified_by: current_user.email))
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

  def ticket_params
    params.require(:ticket).permit(:link, :modified_by, :user_id, :account_id,
                                   ticket_details_attributes: %i[id content access_level ticket_id _destroy])
  end

  def check_role
    @account = Account.find(params[:account_id])

    return if current_user.validate_ticket_access

    redirect_url = @ticket ? account_ticket_url(@account, @ticket) : account_tickets_url(@account)
    redirect_to redirect_url, alert: "You're not allowed to do that!"
  end
end
