class WinesController < ApplicationController
	before_filter :current_user

	def index	
		@wines = Wine.paginate(page: params[:page])
	end

	def show
		@wine = Wine.find(params[:id])
		@user = current_user
	end

end
