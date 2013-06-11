module Ohanakapa
  class Client
    module Organizations

      #TODO move pagination to a superclass or mixin
      #include Ohanakapa::Client::Paginates

      # Get all organizations
      #
      # @return [Hashie::Mash] Hash representing all organizations in database.
      # @example
      #   Ohanakapa.organizations
      # @example
      #   Ohanakapa.orgs
      def organizations(params={:page=>1})
        
        query = get("organizations?",params)

        pagination = query[:pagination]
        @pagination = Ohanakapa::Pagination.new( pagination[:current], pagination[:per_page] , pagination[:count] )
        Ohanakapa::Response.new(query.response,@pagination)
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
        query = get("organizations/#{id}")
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
      alias :org :organization

    end
  end
end
