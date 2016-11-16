# frozen_string_literal:true
class ApplicationController < ActionController::API
  include ApplicationErrors

  before_action :authenticate_user!

  def authenticate_user!
    raise AuthenticationRequired if auth_required? &&
                                    (
                                      auth_token.blank? ||
                                      current_user.nil?
                                    )
  end

  def auth_required?
    return false if params[:controller] == 'v1/users' &&
                    %w(create confirm).include?(params[:action].to_s)
    return false if params[:controller] == 'v1/sessions' &&
                    params[:action].to_s == 'create'

    true
  end

  def current_user
    @current_user ||= User.find_by token: auth_token
  end

  def auth_token
    auth_header = request.headers['HTTP_AUTHORIZATION']

    return nil if auth_header.blank?

    auth = auth_header.split(' ')
    return nil unless auth.first == 'Bearer' && auth.count == 2

    auth.last
  end

  [200, 201].each do |status|
    define_method "render_#{status}" do |json = { meta: {} }, opts = {}|
      render_ok json, status, opts
    end
  end

  def render_ok(json = { meta: {} }, status = 200, opts = {})
    render_json json, status, opts
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

  def render_json(json, status, opts = {})
    render opts.merge(json: json, status: status)
  end
end
