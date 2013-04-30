#-*- coding:utf-8 -*-

MyBookList.controllers :book, :parent=>:account do

  get :search, :map => "/book/search" do
    @title = "本の検索"
    @results = Array.new
    @panel_is_visible = true

    if params[:q].present? then
      results = Book.search(params[:q], :page=>params[:page])
      @results = results if results.present?
    end

    render 'book/search'
  end  

  get :index do
    @account = Account.find(params[:account_id])
    if @account.id == current_account.id then
      @panel_is_visible = true
    end

    if permit_access? then
      @books = @account.books
      render 'book/index'
    else
      halt 403
    end
  end

  post :index, :provides => :json do
    book = Book.where(:asin=> params[:asin]).first_or_create

    if book.errors.present? then
      mes = book.errors.messages.map{|k,v| "#{k}: #{v.join("")}"}.join("\n")
      res = {:status=>"error", :message=>mes}
    else
      current_account.books << book
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
    books = current_account.books.where(:asin=>params[:asin])
    if books.present? then
      current_account.books.delete books
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
