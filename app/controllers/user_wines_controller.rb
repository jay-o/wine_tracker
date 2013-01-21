class UserWinesController < ApplicationController
	before_filter :current_user

	def index
		@wines = @current_user.wines
	end

	def create
		@wine = Wine.find_by_id(params[:user_wine][:wine_id])
		current_user.user_wines.create!(wine_id: @wine.id)
		redirect_to @wine
	end

	def destroy
		@wine = Wine.find_by_id(params[:user_wine][:wine_id])
		current_user.user_wines.find_by_wine_id(@wine.id).destroy
		redirect_to @wine
	end
end
