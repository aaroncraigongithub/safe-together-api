# frozen_string_literal: true
class V1::SessionsController < ApplicationController
  def create
    token = SessionManager.create params[:email], params[:password]

    render_200 token: token
  end
end
