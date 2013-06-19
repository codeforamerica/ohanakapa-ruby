class Home

  # Performs a query of the API
  # @param params [Object] parameter object.
  # @return [Hashie::Mash] Hash representing a organization's details.
  def self.query(params = {})
    client = Ohanakapa.new

    # return all results if keyword and location are blank
    if params[:keyword].blank? && params[:location].blank?
      return client.organizations(params)
    end

    response = client.query(params)
  end

end
