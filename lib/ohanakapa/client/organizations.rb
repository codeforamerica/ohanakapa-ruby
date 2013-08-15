module Ohanakapa
  class Client
    module Organizations

      # Get all organizations
      #
      # @return [Sawyer::Resource] Hash representing all organizations in database.
      # @example
      #   Ohanakapa.organizations
      # @example
      #   Ohanakapa.orgs
      def organizations(options={})  
        get("organizations",options)
      end
      alias :orgs :organizations

      # Get a organization based on its ID
      #
      # @param id [String] Organization ID.
      # @return [Sawyer::Resource] Hash representing organization details.
      # @example
      #   Ohanakapa.organization('519c44065634241897000023')
      # @example
      #   Ohanakapa.org('519c44065634241897000023')
      def organization(id)
        get("organizations/#{id}")
      end
      alias :org :organization

      # Get nearby organizations to an organization, based on its ID
      #
      # @param id [String] Organization ID.
      # @return [Sawyer::Resource] Hash representing nearby organizations.
      # @example
      #   Ohanakapa.nearby('519c44065634241897000023')
      def nearby(id)
        get("organizations/#{id}/nearby")
      end

    end
  end
end
