module Ohanakapa
  class Client
    module Query

      # Performs a query of the API
      # @param params [Object] parameter object.
      # @return [Hashie::Mash] Hash representing a organization's details.
      def query(params)
        params.delete_if { |k, v|
          v.nil? || v.empty? 
        }

        response = get("search?=",params)
        pagination = response[:pagination]
        @pagination = Ohanakapa::Pagination.new( pagination[:current], pagination[:per_page] , pagination[:count] )
        response
      end

      #TODO move pagination to a superclass or mixin
      def pagination
        @pagination
      end

    end
  end
end
