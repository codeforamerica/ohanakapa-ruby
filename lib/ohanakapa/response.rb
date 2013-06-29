module Ohanakapa
  class Response

	  # Initialize response object
    # @param content [String] Content of the response.
    # @param pagination [Ohanakapa::Pagination] Holds pagination information.
  	def initialize(content=nil,pagination=nil)

  		@content = content

  		if pagination.nil?
  			pagination = Ohanakapa::Pagination.new
  		end

  		@pagination = pagination

		end

		def content
			@content
		end

		def pagination
			@pagination
		end

  end
end
