# frozen_string_literal: true
class FriendSerializer < ActiveModel::Serializer
  attributes :id,
             :created_at,
             :updated_at,
             :confirmed_at

  belongs_to :user
  belongs_to :friend, class_name: 'User'

  def id
    object.uuid
  end
end
