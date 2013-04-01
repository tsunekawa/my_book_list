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

  get :index, :map => "/book" do
    @books = Book.all
    render 'book/index'
  end

  post :index, :provides => :json,  :map => "/book" do
    book = Book.new(:asin=> params[:asin])
    book.save
    if book.errors.present? then
      res = {:status=>"error", :message=>"asin:#{params[:asin]} は不正なASINです。"}
    else
      res = {:status=>"success", :message=>"登録完了!"}
    end

    case content_type
    when :json
      res.to_json
    when :html
      erb :index
    end
  end

  post :delete, :provides => :json, :map => "/book/:asin/delete" do
    book = Book.find_by_asin params[:asin]
    if book.present? then
      book.destroy
      res = {:status=>"success", :message=>"削除完了!"}
    else
      status 400
      res = {:status=>"error", :message=>"asin:#{params[:asin]} は不正であるか登録されていません。"}
    end

    case content_type
    when :json
      res.to_json
    when :html
      erb :index
    end
  end

end
