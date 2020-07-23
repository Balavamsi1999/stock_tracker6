class UserStocksController < ApplicationController
	
	def create	 
		stock=Stock.check_db(params[:ticker])

		if !stock.present?
			stock=Stock.new_lookup(params[:ticker])
			stock.save			
		end
		@user_stock=UserStock.create(user:current_user,stock:stock)
		flash[:notice] ="stock #{stock.name} was successfully added to your portfolio"
		redirect_to my_portfolio_path
	end

	def destroy
		UserStock.where(user_id: current_user,stock_id: params[:id]).first.destroy
		flash[:notice] ="stock was successfully deleted"
		redirect_to my_portfolio_path
	end
end
