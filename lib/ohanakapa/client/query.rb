
module Ohanakapa
  class Client
    module Query

      # Performs a query of the API
      # @param params [Object] parameter object.
      # @return [Ohanakapa::Response] Response representing the query results and pagination info.
      def query(params)
        params.delete_if { |k, v|
          v.nil? || v.empty? 
        }

        query = get("search?=",params)
        pagination = query[:pagination]
        @pagination = Ohanakapa::Pagination.new( pagination[:current], pagination[:per_page] , pagination[:count] )
        Ohanakapa::Response.new(query.response,@pagination)
      end

      # Returns an empty result set formatted like a query response
      # @return [Ohanakapa::Response] An empty response object.
      def empty_set
        Ohanakapa::Response.new
      end
    
    end
  end
end
