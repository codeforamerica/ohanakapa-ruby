module Ohanakapa
    class Pagination

      # Initialize pagination linked list
      # @param current [Integer] The current page number.
      # @param per_page [Integer] The number of results per page.
      # @param count [Integer] The total number of results.
      def initialize(current, per_page, count)
        # Instance variables  
        @per_page = per_page                          #per page number
        @count = count                                #total number
        @pages = (count.to_f/per_page.to_f).ceil      #total number of pages
        
        #set pages to 1 if it is zero, at mininum there is one page
        @pages == 0 ? @pages = 1 : @pages 

        # raise error if current is greater than pages
        if (current > @pages)
          raise "current page index cannot be greater than number of pages!"
        end
        
        @current = current                            #current page number
        @prev = current-1 > 0 ? current-1 : nil       #previous page number
        @next = current+1 <= @pages ? current+1 : nil #next page number
        
        calc_items_current

      end

      # Go to a particular page
      # @param current [Integer] Page number to go to.
      # @return [Boolean] True if successfully set page, false if it is out of range.
      def goto_page(current)
        if current > 0 && current <= @pages
          @current = current                          #current page number
          @prev = current-1 > 0 ? current-1 : nil #previous page number
          @next = current+1 <= @pages ? current+1 : nil #next page number
          calc_items_current
          return true
        else
          return false
        end
      end

      # Advance the page by 1
      # @return [Boolean] True if successfully advanced page, false if it is out of range.
      def next_page
        goto_page(@current+1)
      end

      # Retract the page by 1
      # @return [Boolean] True if successfully retracted page, false if it is out of range.
      def prev_page
        goto_page(@current-1)
      end
      
      # Getters for properties

      def items_total
        @count
      end

      def items_current
        @items_current
      end

      def items_per_page
        @per_page
      end

      def pages_total
        @pages
      end

      def current
        @current
      end

      def prev
        @prev
      end

      def next
        @next
      end

      private

      def calc_items_current
        @items_current = @current == @pages ? @count % @per_page : @per_page
      end

    end
end
