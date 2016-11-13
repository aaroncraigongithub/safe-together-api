# frozen_string_literal:true
class Alert < ApplicationRecord
  include Uuid

  belongs_to :user
end
