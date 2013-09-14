module Ohanakapa
  class Client

    # Methods for the Organizations API
    #
    # @see http://ohanapi.herokuapp.com/api/docs
    module Organizations

      # List all organizations
      #
      # This provides a dump of every organization, in the order that they
      # were uploaded to the Ohana DB.
      #
      # @see http://ohanapi.herokuapp.com/api/docs#!/api/GET-api-organizations---format-_get_0
      #
      # @return [Array<Sawyer::Resource>] List of Organizations.
      #
      # @example
      #   Ohanakapa.organizations
      # @example
      #   Ohanakapa.orgs
      def organizations
        get "organizations"
      end
      alias :orgs :organizations

      # Get a single organization based on its ID
      # @see http://ohanapi.herokuapp.com/api/docs#!/api/GET-api-organizations--id---format-_get_1
      #
      # @param id [String] Organization ID.
      # @return [Sawyer::Resource]
      # @example
      #   Ohanakapa.organization('519c44065634241897000023')
      # @example
      #   Ohanakapa.org('519c44065634241897000023')
      def organization(id)
        get("organizations/#{id}")
      end
      alias :org :organization

    end
  end
end
