require 'pry'

class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, except: %i[index new create accept_invitation]
  before_action :authenticate_account_access, only: :show
  
  def index
    filtered_accounts = filter_by_site

    @pagy, @accounts = pagy(filtered_accounts)
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
    @account = Account.new(account_params.merge(user_uid: current_user.uid))

    if @account.save
      
      @account.users << current_user
      redirect_to account_url(@account), notice: 'Account successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @account.update(account_params)
      redirect_to account_url(@account), notice: 'Account successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @account.destroy
    redirect_to accounts_path, notice: 'Successfully destroyed!'
  end

  def join
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
    result = @account.invite_user(email)
    redirect_to account_settings_path(@account), notice: result
  end
  
  def accept_invitation
    result = Account.accept_invitation(params[:token])

    if result[:success]
      redirect_to account_path(result[:account]), notice: result[:message]
    else
      redirect_to accounts_settings_path, alert: result[:message]
    end
  end

  def remove
    email = params[:email]
    @user = User.find_by(email:)

    if @user && @user != current_user
      @account.users.delete(@user)
      redirect_to account_settings_path(@account), notice: 'Successfully removed the user.'
    else
      redirect_to account_settings_path(@account), alert: 'User with the provided email not found.'
    end
  end

  private

  def set_account
    @account = Account.find(params[:id])
    redirect_to @account, status: :moved_permanently if params[:id] != @account.slug
  end

  def account_params
    params.require(:account).permit(:name, :site, :slug)
  end

  def authenticate_account_access
    return if @account.member?(current_user)

    redirect_to accounts_path, alert: "You do not have access to view this account."
  end

  def filter_by_site
    site = params[:filter_by]

    return Account.includes(:users).all if site == 'all' || site.blank?

    Account.includes(:users).where(site:).all
  end
end
