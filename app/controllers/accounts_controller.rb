require 'pry'

class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin?, except: %i[index show join leave invite remove accept_invitation edit update]
  # before_action :validate_before_joining, only: %i[join invite]
  # before_action :authenticate_account_access, only: :show
  before_action :authenticate_remove_access, only: :remove
  # TODO: Implement helper, only admin or role that are similar to admin can create new account.
  before_action :set_account, except: %i[index new create accept_invitation]

  def index
    filtered_accounts = filter_by_site

    @pagy, @accounts = pagy(filtered_accounts.order(created_at: :asc))
    @total_accounts = Account.count

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    @user = User.new
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)

    if @account.save
      redirect_to account_path(@account), notice: 'Account successfully created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @account.update(account_params)
      redirect_to account_path(@account), notice: "#{@account.name} was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @account.destroy
    redirect_to accounts_path, notice: 'Successfully destroyed!'
  end

  def join
    return if validate_before_joining(current_user)

    @account.users << current_user
    redirect_to account_url(@account), notice: 'You have joined the account.'
  end

  def leave
    @account.users.delete(current_user)
    redirect_to accounts_url, notice: 'You have left the account.'
  end

  # rubocop:disable Metrics/MethodLength
  def invite
    email = params[:user][:email]
    @user = User.find_by(email:)

    if @user
      return if validate_before_joining(@user)

      if @account.users.include?(@user)
        redirect_to account_path(@account), notice: 'User is already a member in this account.'
      else
        # @account.users << @user
        # redirect_to account_path(@account), notice: 'User has been invited to the account.'
        # Generate a unique token

        token = SecureRandom.urlsafe_base64(32)
        # Calculate and set the expiration time (e.g., 24 hours from now)
        expiration_time = 36.hours.from_now

        # Create an invitation
        invitation = AccountInvitation.new(account: @account, user: @user, accepted: false, token:,
                                           expires_at: expiration_time)
        if invitation.save
          # Send an invitation with a link to accept
          AccountInvitationMailer.invite(invitation).deliver_now!

          redirect_to account_path(@account), notice: 'User has been invited to the account.'
        else
          redirect_to account_path(@account), alert: 'Failed to create an invitation.'
        end
      end
    else
      redirect_to account_path(@account), alert: 'User with the provided email not found.'
    end
  end

  def accept_invitation # rubocop:disable Metrics/AbcSize
    invitation = AccountInvitation.find_by(token: params[:token])

    if invitation
      if invitation.expires_at >= Time.now
        invitation.update(accepted: true, accepted_at: Time.now)
        invitation.account.users << invitation.user
        redirect_to account_path(invitation.account), notice: 'Invitation accepted, user added to the account.'
      else
        redirect_to root_path, alert: 'Invitation already expired, please create a new one.'
      end
    else
      redirect_to root_path, alert: 'Invalid invitation link.'
    end
  end
  # rubocop:enable Metrics/MethodLength

  def remove
    email = params[:email]
    @user = User.find_by(email:)

    if @user && @user != current_user
      @account.users.delete(@user)
      redirect_to account_url(@account), notice: 'Successfully removed the user.'
    else
      redirect_to account_url(@account), alert: 'User with the provided email not found.'
    end
  end

  private

  def set_account
    @account = Account.find(params[:id])

    # If an old id or numeric id was used to find the record,
    # then the request slug will not match the current slug,
    # and we should do a 301 redirect to a new path.
    # return unless params[:id] != @account.slug
    redirect_to @account, status: :moved_permanently if params[:id] != @account.slug
  end

  def account_params
    params.require(:account).permit(:name, :description, :site, :enable_kpi)
  end

  def authenticate_account_access
    @account = Account.find(params[:id])
    redirect_to accounts_url, notice: "You're not a member of the account." unless @account.users.include?(current_user)
  end

  def authenticate_remove_access
    return if current_user.admin? || current_user.manager?

    redirect_to accounts_url,
                notice: "You're not authorized to remove a member of the account."
  end

  # Confirm if the user and their role can have multiple accounts,
  # Both Manager and QA are allow to multiple accounts.
  def validate_before_joining(user)
    return unless user.validate_account_limit

    redirect_to accounts_url, notice: "#{user.email} have reach your maximum account allowed."
  end

  def filter_by_site
    site = params[:filter_by]

    return Account.includes(:users).all if site == 'all' || site.blank?

    Account.includes(:users).where(site:).all
  end
end
