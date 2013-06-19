class HomeController < ApplicationController
  def index

  	query = Home.query({'page'=>58})
		@content = query.content
		@pagination = query.pagination

  end

end
