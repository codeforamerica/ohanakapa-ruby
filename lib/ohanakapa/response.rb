module Ohanakapa
  class Response

	  # Initialize response object
    # @param response [Hash] Holds response hash.
    # @param pagination [Pagination] Holds pagination information.
  	def initialize(response,pagination=nil)
  		@response = response
  		@pagination = pagination
		end

		def content
			@response
		end

		def pagination
			@pagination
		end

  end
end
