# frozen_string_literal:true
class ApplicationController < ActionController::API
  include ApplicationErrors

  before_action :authenticate_user!

  def authenticate_user!
    raise AuthenticationRequired if auth_required? && current_user.nil?
  end

  def auth_required?
    return false if params[:controller] == 'v1/users' &&
                    %w(create confirm).include?(params[:action])
    return false if params[:controller] == 'v1/sessions' &&
                    params[:action] == 'create'

    true
  end

  def current_user
    @current_user ||= User.find_by token: auth_token
  end

  def auth_token
    request.headers['HTTP_AUTHORIZATION']
  end

  [200, 201].each do |status|
    define_method "render_#{status}" do |json = { meta: {} }|
      render_ok json, status
    end
  end

  def render_ok(json = { meta: {} }, status = 200)
    render_json json, status
  end

  [400, 401, 403, 404, 412, 422, 423, 424, 502].each do |status|
    define_method "render_#{status}" do |e, json = {}|
      render_error json, status, e
    end
  end

  def render_error(json = {}, status = 500, e = nil)
    NewRelic::Agent.notice_error e
    Rails.logger.debug e

    payload = {
      message: e.message || ''
    }.merge(json)

    render_json({ errors: [payload] }, status)
  end

  def render_json(json, status)
    render(json: json, status: status)
  end
end
