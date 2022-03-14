class PagesController < ApplicationController
  skip_before_action :require_login
  def top; end
  def terms; end
  def policy; end
  def contact; end
end
