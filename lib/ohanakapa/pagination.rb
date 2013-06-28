module Ohanakapa
    class Pagination

      # Initialize pagination linked list
      # @param optional current [Integer] The current page number, defaults to 1.
      # @param optional per_page [Integer] The number of results per page, defaults to 30.
      # @param optional count [Integer] The total number of results, defaults to 0.
      def initialize(current_page=1, per_page=30, count=0)
        # Instance variables  
        @per_page = per_page                          #per page number
        @count = count                                #total number
        @pages = (count.to_f/per_page.to_f).ceil      #total number of pages
        
        #set pages to 1 if it is zero, at mininum there is one page
        @pages == 0 ? @pages = 1 : @pages 

        # raise error if current is greater than pages or less than 1
        if (goto_page(current_page) == false)
          raise "current page index cannot be greater than number of pages or less than 1!"
        end
        
      end

      # Go to a particular page
      # @param current [Integer] Page number to go to.
      # @return [Boolean] True if successfully set page, false if it is out of range.
      def goto_page(current_page)
        if current_page > 0 && current_page <= @pages
          @current_page = current_page                            #current page number
          @prev = current_page-1 > 0 ? current_page-1 : nil       #previous page number
          @next = current_page+1 <= @pages ? current_page+1 : nil #next page number
          calc_items_current
          return true
        else
          return false
        end
      end

      # Advance the page by 1
      # @return [Boolean] True if successfully advanced page, false if it is out of range.
      def next_page
        goto_page(@current_page+1)
      end

      # Retract the page by 1
      # @return [Boolean] True if successfully retracted page, false if it is out of range.
      def prev_page
        goto_page(@current_page-1)
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
        @current_page
      end

      def prev
        @prev
      end

      def next
        @next
      end

      private

      # calculate the number of items on the current page
      def calc_items_current
        
        @items_current = @current_page == @pages ? @count % @per_page : @per_page
      end

    end
end
