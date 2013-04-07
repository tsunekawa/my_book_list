#-*- coding:utf-8 -*-

MyBookList.controllers :book, :parent=>:account do
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

  get :index do
    @account = Account.find(params[:account_id])
    if logged_in? and current_account.id == @account.id then
      @books = @account.books
      render 'book/index'
    else
      halt 403
    end
  end

  post :index, :provides => :json do
    book = current_account.books.create :asin=> params[:asin]
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

  delete :index, :provides => :json do
    book = Book.find_by_asin params[:asin]
    if book.present? then
      current_account.books.delete book
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
