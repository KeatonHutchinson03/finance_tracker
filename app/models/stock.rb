class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true

  def self.new_lookup(ticker_symbol)
    service = FinnhubService.new(ticker_symbol)
    data = service.full_data

    quote_data = data[:quote]
    profile_data = data[:profile]

    # Detect invalid symbols
    invalid_quote = quote_data.blank? || quote_data['c'].to_f <= 0
    invalid_profile = profile_data.blank? || profile_data['name'].blank?

    return nil if invalid_quote && invalid_profile

    stock = Stock.find_or_initialize_by(ticker: ticker_symbol.upcase)
    stock.last_price = quote_data['c']
    stock.name = profile_data['name'] || ticker_symbol.upcase
    

    stock
  rescue StandardError => e
    Rails.logger.error("Stock lookup error: #{e.message}")
    nil
  end

  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
  end
end
