class ImprintController < ApplicationController
  skip_before_action :authenticate_user!
  before_action { @section = 'imprint' }

  # GET /imprint
  # GET /imprint.json
  def index
  end

end
