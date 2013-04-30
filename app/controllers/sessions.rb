MyBookList.controllers :sessions do

  get :new do
    render "/sessions/new", nil
  end

  post :create do
    if account = Account.authenticate(params[:email], params[:password])
      set_current_account(account)
      logger.info "login: #{current_account.name}"
      redirect url_for(:top, :top)
    elsif Padrino.env == :development && params[:bypass]
      account = Account.first
      set_current_account(account)
      logger.info "login: #{current_account.name}"
      redirect url_for(:top, :top)
    else
      params[:email], params[:password] = h(params[:email]), h(params[:password])
      flash[:warning] = "Login or password wrong."
      redirect url(:sessions, :new)
    end
  end

  delete :destroy do
    logger.info "logout: #{current_account.name}"
    set_current_account(nil)
    redirect url(:sessions, :new)
  end
end
