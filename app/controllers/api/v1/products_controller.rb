class Api::V1::ProductsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User

  def index
    @products = policy_scope(Product)
    render json: @products
  end
end
