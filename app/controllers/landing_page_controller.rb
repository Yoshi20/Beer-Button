class LandingPageController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  # GET /landing_page
  def index
  end

end
