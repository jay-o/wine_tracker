class WinesController < ApplicationController

	def index
		@wines = Wine.paginate(page: params[:page])
	end

	def show
		@wine = Wine.find(params[:id])
	end

end
