module Ohanakapa
  class Client

    # Methods for the Locations API
    #
    # @see http://ohanapi.herokuapp.com/api/docs
    module Locations

      # List all locations
      #
      # This provides a dump of every location, in the order that they
      # were uploaded to the Ohana DB.
      #
      # @see http://ohanapi.herokuapp.com/api/docs#!/api/GET-api-locations---format-_get_0
      #
      # @return [Array<Sawyer::Resource>] List of Locations.
      #
      # @example
      #   Ohanakapa.locations
      # @example
      #   Ohanakapa.locs
      def locations(options={})
        paginate "locations", options
      end
      alias :locs :locations

      # Get a single location based on its ID
      # @see http://ohanapi.herokuapp.com/api/docs#!/api/GET-api-locations--id---format-_get_1
      #
      # @param id [String] location ID.
      # @return [Sawyer::Resource]
      # @example
      #   Ohanakapa.location('519c44065634241897000023')
      # @example
      #   Ohanakapa.loc('519c44065634241897000023')
      def location(id)
        get("locations/#{id}")
      end
      alias :loc :location

      # Get nearby locations to an location, based on its ID
      #
      # @param id [String] location ID.
      # @param options [Hash] A customizable set of options.
      # @option options [Float] :radius
      # @return [Sawyer::Resource] Hash representing nearby locations.
      # @example
      #   Ohanakapa.nearby('519c44065634241897000023', :radius => 0.5)
      def nearby(id, options={})
        get("locations/#{id}/nearby", options)
      end

      # Update a location
      #
      # @param id [String] location ID.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :kind
      # @return [Sawyer::Resource]
      # @example
      #   Ohanakapa.update_location("521d33a01974fcdb2b0036a9", :kind => "entertainment")
      def update_location(id, options)
        put "locations/#{id}", :query => options
      end

    end
  end
end
