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
      def organizations(params={})  
        get("organizations",params)
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
        get("organizations/#{id}")
      end
      alias :org :organization

=begin
      # Get nearby organizations to an organization, based on its ID
      #
      # @param id [String] Organization ID.
      # @return [Hashie::Mash] Hash representing nearby organizations.
      # @example
      #   Ohanakapa.nearby('519c44065634241897000023')
      def nearby(id)
        query = get("organizations/#{id}/nearby")
        error = query.error

        pagination = query[:pagination]
        @pagination = Ohanakapa::Pagination.new( pagination[:current], pagination[:per_page] , pagination[:count] )
        Ohanakapa::Response::Wrapper.new(query.response,@pagination)

        if error.nil?
          response = Ohanakapa::Response::Wrapper.new(query.response)
          return response
        elsif error == "not_found"
          raise Ohanakapa::NotFound
        elsif error == "bad_request"
          raise Ohanakapa::BadRequest
        end

      end
=end      

    end
  end
end
