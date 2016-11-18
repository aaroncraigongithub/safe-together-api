# frozen_string_literal:true
class V1::UsersController < ApplicationController
  def show
    render_200 current_user
  end

  def create
    user = UserManager.create(
      email:    params[:email],
      password: params[:password]
    )

    render_200 user
  end

  def confirm
    user = UserManager.confirm params[:token]

    render_200 user
  end
end
