# frozen_string_literal:true
require 'rails_helper'

RSpec.describe V1::AlertsController, type: :controller do
  describe 'POST /alerts' do
    before do
      process :create, method: :post
    end
  end

  describe 'PUT /alerts' do


  end

  describe 'DELETE /alerts' do

  end

  describe 'GET /alerts' do

  end
end
