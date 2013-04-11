MyBookList.controllers :account do
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

  get :index, :map => "/account/" do
    halt 403 unless current_account.role.to_sym==:admin
    @accounts = Account.all
    render 'account/index'
  end

  get :show, :map => "/account/:account_id" do
    @account = Account.find(params[:account_id])
    redirect url_for(:book, :index, :account_id=>@account.id)
  end

  get :setting, :map => "/account/:account_id/setting" do
    @account = Account.find(params[:account_id])
    halt 403 unless logged_in? and current_account.id == @account.id
    render 'account/setting'
  end

  put :update, :map => "/account/:account_id" do
    @account = Account.find(params[:account_id])
    halt 403 unless logged_in? and current_account.id == @account.id
    params[:account].delete(:role) if current_account.role.to_sym != :admin

    if @account.update_attributes(params[:account])
      flash[:notice] = 'Account was successfully updated.'
      redirect url(:account, :setting, :account_id => @account.id)
    else
      render 'account/edit'
    end
  end

end
