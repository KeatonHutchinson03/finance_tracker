class StocksController < ApplicationController
  def search
    stock_symbol = params[:stock]

    if stock_symbol.present?
      @stock = Stock.new_lookup(stock_symbol)
      if @stock
        render 'users/my_portfolio'
      else
        redirect_to my_portfolio_path, alert: "Stock symbol not found. Please try again."
      end
    else
      redirect_to my_portfolio_path, alert: "Please enter a stock symbol."
    end
  end
end
