module Ohanakapa
  class Client

    # Methods for the Categories API
    #
    # @see http://ohanapi.herokuapp.com/api/docs
    module Categories

      # List all categories
      #
      # This provides a dump of every category, in the order that they
      # were uploaded to the Ohana DB.
      #
      # @see http://ohanapi.herokuapp.com/api/docs#!/api/GET-api-categories---format-_get_0
      #
      # @return [Array<Sawyer::Resource>] List of Categories.
      #
      # @example
      #   Ohanakapa.categories
      # @example
      #   Ohanakapa.cats
      def categories(options={})
        paginate "categories", options
      end
      alias :cats :categories

      # Get a single category based on its ID
      # @see http://ohanapi.herokuapp.com/api/docs#!/api/GET-api-categories--id---format-_get_1
      #
      # @param id [String] category ID.
      # @return [Sawyer::Resource]
      # @example
      #   Ohanakapa.category('519c44065634241897000023')
      # @example
      #   Ohanakapa.cat('519c44065634241897000023')
      def category(id)
        get("categories/#{id}")
      end
      alias :cat :category

    end
  end
end
