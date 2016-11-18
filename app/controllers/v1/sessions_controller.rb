# frozen_string_literal: true
class V1::SessionsController < ApplicationController
  def create
    user = SessionManager.create params[:email], params[:password]

    render_200 user
  end
end
