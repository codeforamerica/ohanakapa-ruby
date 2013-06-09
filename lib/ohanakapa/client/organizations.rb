module Ohanakapa
  class Client
    module Organizations

      # Get all organizations
      #
      # @return [Hashie::Mash] Hash representing all organizations in database.
      # @example
      #   Ohanakapa.organizations
      # @example
      #   Ohanakapa.orgs
      def organizations
        response = get("organizations")

        pagination = response[:pagination]
        @pagination = Ohanakapa::Pagination.new( pagination[:current], pagination[:per_page] , pagination[:count] )
        response
      end
      alias :orgs :organizations

      # Get a organization based on its ID
      #
      # @param id [String] Organization ID.
      # @return [Hashie::Mash] Hash representing organization details.
      # @example
      #   Ohanakapa.organization('519c44065634241897000023')
      # @example
      #   Ohanakapa.org('519c44065634241897000023')
      def organization(id)
        response = get("organizations/#{id}")
        error = response.error

        if error.nil?
          return response
        elsif error == "not_found"
          raise Ohanakapa::NotFound
        elsif error == "bad_request"
          raise Ohanakapa::BadRequest
        end

      end
      alias :org :organization

      #TODO move pagination to a superclass or mixin
      def pagination
        @pagination
      end

    end
  end
end
