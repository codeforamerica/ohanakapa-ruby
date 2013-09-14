module Ohanakapa
  class Client

    # Methods for the Search API
    #
    # @see http://ohanapi.herokuapp.com/api/docs#!/api/GET-api-search---format-_get_11
    module Search

      # Performs a query of the API
      # @param options [Hash] Search term and qualifiers
      # @option options [String] :keyword Keyword search term
      # @option options [String] :location Location search term
      # @option options [Float]  :radius Distance in miles from Location
      # @option options [String] :language Language spoken at Location
      # @option options [Fixnum] :page Page of paginated results
      # @return [Sawyer::Resource] Search results object
      def search(path, options = {})
        paginate path, options
      end

    end
  end
end
