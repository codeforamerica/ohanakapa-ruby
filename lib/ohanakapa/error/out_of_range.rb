module Ohanakapa
  class Error
    # Raised when a pagination object is initialized with a page number 
    # that is out of range of the results
    class OutOfRange < Ohanakapa::Error
      MESSAGE = "Page parameter is out of range"
    end
  end
end
