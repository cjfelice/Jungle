class Admin::DashboardController < ApplicationController

  http_basic_authenticate_with name: "Jungle", password: "book"

  def show
    @categoryCount = Category.count
    @productCount = Product.count
  end
end
