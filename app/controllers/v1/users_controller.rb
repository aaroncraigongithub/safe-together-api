# frozen_string_literal:true
class V1::UsersController < ApplicationController
  def create
    token = UserManager.create(
      email:    params[:email],
      password: params[:password]
    )

    render_200 token: token
  end

  def confirm
    UserManager.confirm params[:token]

    render_200
  end
end
