class StocksController < ApplicationController
  def search
    stock_symbol = params[:stock]

    if stock_symbol.present?
      @stock = Stock.new_lookup(stock_symbol)
      if @stock
        respond_to do |format|
          format.js { render partial: 'users/result' }  # Renders result.js.erb for
        end
      else
        respond_to do |format|
          flash.now[:alert] = "Please enter a valid stock symbol."
          format.js { render partial: 'users/result' }
        end
      end
    else
      respond_to do |format|
          flash.now[:alert] = "Please enter a symbol to search."
          format.js { render partial: 'users/result' }
        end
    end
  end
end
