# frozen_string_literal: true
module ApplicationErrors
  extend ActiveSupport::Concern

  class AuthenticationRequired < StandardError; end

  included do
    rescue_from AuthenticationRequired do |e|
      render_403 e
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      render_404 e
    end

    rescue_from UserManager::TokenAlreadyUsed do |e|
      render_422 e
    end

    rescue_from AlertManager::ConfirmedUserRequired do |e|
      render_422 e
    end

    rescue_from PG::UniqueViolation do |e|
      render_422 e
    end

    rescue_from PG::NotNullViolation do |e|
      render_422 e
    end

    rescue_from ArgumentError do |e|
      render_422 e
    end

    rescue_from ActionController::ParameterMissing do |e|
      render_422 e
    end
  end
end
