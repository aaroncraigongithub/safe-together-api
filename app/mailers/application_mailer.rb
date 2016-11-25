# frozen_string_literal: true
class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAIL_DEFAULT_FROM']
  layout 'mailer'
end
