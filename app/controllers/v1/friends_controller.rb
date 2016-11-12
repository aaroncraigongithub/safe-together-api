# frozen_string_literal: true
class V1::FriendsController < ApplicationController
  def add
    UserManager.add_friends current_user.id, params[:user_ids]

    render_200
  end

  def invite
    UserManager.invite_friends current_user.id, params[:emails]

    render_200
  end
end
