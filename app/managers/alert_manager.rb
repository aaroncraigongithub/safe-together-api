# frozen_string_literal:true
class AlertManager
  class ConfirmedUserRequired < StandardError; end

  def self.create(user_id)
    user = User.find user_id
    raise ConfirmedUserRequired if user.confirmed_at.nil?

    if user.alert.present?
      escalate_alert user.alert
    else
      create_alert user
    end
  end

  def self.create_alert(user)
    alert = user.alerts.create!

    PusherAlertWorker.perform_async alert.id
  end

  def self.escalate_alert(alert)
    alert.level += 1
    alert.save!

    PusherAlertLevelWorker.perform_async alert.id
  end
end
