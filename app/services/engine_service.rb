class EngineService

  def self.all_purposes
    Rails.cache.fetch("all_purposes", expires_in: 24.hours) do
      response = connection.get('/api/v1/purposes')
      JSON.parse(response.body, symbolize_names: true)
    end
  end

  def self.create_yard(yard_params)
    response = connection.post('/api/v1/yards') do |req|
      req.headers["CONTENT_TYPE"] = "application/json"
      req.params = yard_params
    end

    JSON.parse(response.body, symbolize_names: true)
  end

  def self.update_yard(yard_params)
    response = connection.put("/api/v1/yards/#{yard_params[:id]}") do |req|
      req.headers["CONTENT_TYPE"] = "application/json"
      req.params = yard_params
    end

    JSON.parse(response.body, symbolize_names: true)
  end

  def self.yard_details(yard_id)
    response = connection.get("/api/v1/yards/#{yard_id}")
    JSON.parse(response.body, symbolize_names: true)[:data]
  end

  def self.host_yards(host_id)
    response = connection.get("/api/v1/hosts/#{host_id}/yards")
    JSON.parse(response.body, symbolize_names: true)
  end


  def self.yards_in_location(yard_params)
    response = connection.get('/api/v1/yards/yard_search') do |req|
      req.headers["CONTENT_TYPE"] = "application/json"
      req.params = yard_params
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.renter_bookings_by_status(renter_id, status)
    response = connection.get("/api/v1/renters/#{renter_id}/bookings?status=#{status}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.create_booking(booking_params)
    response = connection.post('/api/v1/bookings') do |req|
      req.headers["CONTENT_TYPE"] = "application/json"
      req.params = booking_params
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.connection
    Faraday.new(url: ENV['ys_engine_url'])
  end
end
