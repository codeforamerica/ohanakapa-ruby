module Ohanakapa
  class Client
    module Organizations
      module Nearby

      # Get nearby organizations to an organization, based on its ID
      #
      # @param id [String] Organization ID.
      # @return [Hashie::Mash] Hash representing nearby organizations.
      # @example
      #   Ohanakapa.nearby('519c44065634241897000023')
      def nearby(id)
        query = get("organizations/#{id}/nearby")
        error = query.error

        if error.nil?
          response = Ohanakapa::Response.new(query.response)
          return response
        elsif error == "not_found"
          raise Ohanakapa::NotFound
        elsif error == "bad_request"
          raise Ohanakapa::BadRequest
        end

      end
      
    end
  end
end
