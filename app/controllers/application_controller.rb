class ApplicationController < ActionController::Base
  before_action :require_login, :ensure_domain
  FQDN = Rails.application.credentials[:domain]

  private

  def not_authenticated
    flash[:alert] = 'ログインしてください'
    redirect_to login_path
  end

  def ensure_domain
    return unless request.host.match?(/\.herokuapp.com/)

    port = ":#{request.port}" unless [80, 443].include?(request.port)
    redirect_to "#{request.protocol}#{FQDN}#{port}#{request.path}", status: :moved_permanently
  end
end
