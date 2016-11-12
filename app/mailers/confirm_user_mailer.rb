# frozen_string_literal:true
class ConfirmUserMailer < ApplicationMailer
  def send_mail(user_id)
    @user = User.find user_id

    mail(to: @user.email, subject: 'Confirm your Stronger Together account')
  end
end
