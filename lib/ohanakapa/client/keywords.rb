module Ohanakapa
  class Client

    # Methods for adding Keywords to a service
    #
    # @see http://ohanapi.herokuapp.com/api/docs
    module Keywords

      # Add keywords to a Service
      #
      # @param service_id [String] Number ID of the service
      # @param keywords [Array] An array of keywords to use as replacement
      # @return [<Sawyer::Resource>] The updated service
      # @see http://ohanapi.herokuapp.com/api/docs
      # @example Add keywords to service with ID '521d339f1974fcdb2b00573e'
      #   Ohanakapa.add_keywords_to_a_service("521d339f1974fcdb2b00573e", ['testing', 'api'])
      def add_keywords_to_a_service(service_id, keywords)
        post "services/#{service_id}/keywords", :query => { :keywords => keywords }
      end


    end
  end
end
