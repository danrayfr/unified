class AccountInvitationMailer < ApplicationMailer
  def invite(invitation)
    @invitation = invitation
    mail(to: @invitation.user.email,
         subject: "[Ninjafied - account invitation mailer test]
         You have been invited to join #{@invitation.account.name} account")
  end
end
