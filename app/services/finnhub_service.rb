# app/services/finnhub_service.rb
class FinnhubService
  include HTTParty
  base_uri 'https://finnhub.io/api/v1'

  def initialize(symbol)
    @symbol = symbol.upcase
    @api_key = ENV['FINNHUB_API_KEY'] || raise("FINNHUB_API_KEY environment variable is not set!")
  end

  # Fetch current stock price and related info
  def quote
    response = self.class.get('/quote', query: { symbol: @symbol, token: @api_key })
    JSON.parse(response.body)
  rescue StandardError => e
    Rails.logger.error("Finnhub quote error: #{e.message}")
    {}
  end

  # Fetch company profile (name, industry, logo, etc.)
  def profile
    response = self.class.get('/stock/profile2', query: { symbol: @symbol, token: @api_key })
    JSON.parse(response.body)
  rescue StandardError => e
    Rails.logger.error("Finnhub profile error: #{e.message}")
    {}
  end

  # Combine quote and profile into a single hash
  def full_data
    { quote: quote, profile: profile }
  end
end
