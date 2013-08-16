require 'json'

module Ohanakapa
  class Client
    module Search

      # Performs a query of the API
      # @param options [Hash] Search term and qualifiers
      # @option options [String] :keyword Keyword search term
      # @option options [String] :location Location search term
      # @option options [String] :sort Sort field
      # @option options [String] :order Sort direction (asc or desc)
      # @option options [Fixnum] :page Page of paginated results
      # @return [Sawyer::Resource] Search results object
      def search(options = {})
        perform_search "search", options
      end

      # Returns an empty result set formatted like a query response
      # @return [Ohanakapa::Response::Wrapper] An resource object.
      def empty_set
        Ohanakapa::Response::Wrapper.new
      end



      private

      # separated as a private method in case search endpoint variations are later needed
      def perform_search(path, options = {})
        options[:accept] ||= "application/vnd.ohanakapa.alpha"
        
        paginate path, options
      end
    
    end
  end
end
