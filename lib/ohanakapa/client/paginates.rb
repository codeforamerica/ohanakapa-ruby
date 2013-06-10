module Ohanakapa
  class Client
    module Paginates

      def pagination
        @pagination
      end

      # Go to a particular page
      # @param current [Integer] Page number to go to.
      # @return [Boolean] True if successfully set page, false if it is out of range.
      def goto_page(current)
        pagination.goto_page(current)
      end

      # Advance the page by 1
      # @return [Boolean] True if successfully advanced page, false if it is out of range.
      def next_page
        pagination.goto_page(@current+1)
      end

      # Retract the page by 1
      # @return [Boolean] True if successfully retracted page, false if it is out of range.
      def prev_page
        pagination.goto_page(@current-1)
      end
      
      # Getters for properties

      def items_total
        pagination.items_total
      end

      def items_current
        pagination.items_current
      end

      def items_per_page
        pagination.items_per_page
      end

      def pages_total
        pagination.pages_total
      end

      def current
        pagination.current
      end

      def prev
        pagination.prev
      end

      def next
        pagination.next
      end

    end
  end
end
