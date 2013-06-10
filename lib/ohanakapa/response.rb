module Ohanakapa
  class Response

	  # Initialize response object
    # @param response [Hash] Holds response hash.
    # @param pagination [Pagination] Holds pagination information.
  	def initialize(content,pagination=nil)
  		@content = content
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
