class Admin::BaseController < ApplicationController
  before_filter :authenticate_as_admin

private
  def authenticate_as_admin
    unless user_is_an_admin?
      redirect_to root_path, alert: 'You must first login as an admin to do that!'
    end
  end

  def user_is_an_admin?
    current_user && current_user.has_role?(:admin)
  end
end
