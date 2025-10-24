class Stock < ApplicationRecord
  def self.new_lookup(ticker_symbol)
    service = FinnhubService.new(ticker_symbol)
    data = service.full_data

    quote_data = data[:quote]
    profile_data = data[:profile]

    return nil if quote_data.blank? || quote_data['c'].nil?

    stock = Stock.find_or_initialize_by(ticker: ticker_symbol.upcase)
    stock.last_price = quote_data['c']
    stock.name = profile_data['name'] || ticker_symbol.upcase
    stock.save!

    stock
  rescue StandardError => e
    Rails.logger.error("Stock lookup error: #{e.message}")
    nil
  end
end
