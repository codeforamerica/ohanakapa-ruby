module Ohanakapa
  module Response
    class Wrapper

  	  # Initialize response wrapper object
      # @param response [Sawyer::Response] Content of the response.
    	def initialize(response=nil)

        if response.nil?
          @content = nil
          @pagination = Ohanakapa::Response::Pagination.new
        else
          @content = response.data.response


          if response.data.respond_to? :pagination
            pagination = response.data.pagination 
            @pagination = Ohanakapa::Response::Pagination.new({:current_page=>pagination.current,\
              :per_page=>pagination.per_page, :count=>pagination.count})
          else
            @pagination = Ohanakapa::Response::Pagination.new
          end

        end

      end

  		def content
  			@content
  		end

      def pagination
        @pagination
      end

    end
  end
end
