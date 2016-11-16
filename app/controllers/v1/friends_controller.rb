# frozen_string_literal: true
class V1::FriendsController < ApplicationController
  def show
    render_200 current_user.friends, include: %w(user friend)
  end

  def add
    FriendManager.add current_user.id, params[:user_ids]

    render_200
  end

  def invite
    FriendManager.invite current_user.id, params[:emails]

    render_200
  end

  def confirm
    FriendManager.confirm params[:token]

    render_200
  end
end
