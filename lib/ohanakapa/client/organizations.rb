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
        response = get("organizations").response
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
        response = get("organizations/#{id}").response
        if response.nil?
          raise Ohanakapa::NotFound
        end
        response
      end
      alias :org :organization

    end
  end
end
