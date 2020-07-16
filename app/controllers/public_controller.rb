class PublicController < ApplicationController
  def main
  end

  def userpage
  end

  def adminpage
  	@current_time = DateTime.current
  	@year = 2020
  	@month = 5
  end
end
