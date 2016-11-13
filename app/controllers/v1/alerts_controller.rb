class V1::AlertsController < ApplicationController
  def create
    AlertManager.create(current_user.id)

    render_200
  end
end
