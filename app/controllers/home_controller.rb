class HomeController < ApplicationController
  def index
    redirect_to profiles_url if user_signed_in?
  end
end
