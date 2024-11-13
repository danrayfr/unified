module Users
  class InvitationsController < Devise::InvitationsController
    def create
      user = User.new(invite_params)

      if user.invite!
        redirect_to root_path, notice: 'Invitation sent successfully.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def invite_params
      params.require(:user).permit(:email, :role)
    end
  end
end
