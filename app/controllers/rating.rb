MyBookList.controllers :rating, :parent=>:account do

  get :index, :map => "/rating" do
    @ratings = current_account.ratings
    render 'rating/index'
  end

  post :update, :map => "/rating" do
  end

  # get :sample, :map => "/sample/url", :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  # get "/example" do
  #   "Hello world!"
  # end

  
end
