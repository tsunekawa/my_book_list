MyBookList.controllers :book do
  # get :index, :map => "/foo/bar" do
  #   session[:foo] = "bar"
  #   render 'index'
  # end

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

  get :search, :map => "/book/search" do
    @title = "本の検索"
    @results = Array.new

    if params[:q].present? then
      results = Book.search(params[:q], :page=>params[:page])
      @results = results if results.present?
    end

    render 'book/search'
  end  

  post :index, :map => "/book" do
    book = Book.new(:asin=> params[:asin])
    book.save
    if book.errors.present? then
      halt 400, book.error
    else
      status 200
      "success!"
    end
  end

  post :delete, :map => "/book/:asin/delete" do
    book = Book.find_by_asin params[:asin]
    if book.present? then
      book.destroy
      status 200
      "success!"
    else
      status 400
      "asin:#{params[:asin]} は不正であるか登録されていません。"
    end
  end

end
