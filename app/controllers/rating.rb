MyBookList.controllers :rating, :parent=>:account do

  get :index do
    @account = Account.find(params[:account_id])
    @ratings = @account.ratings
    render 'rating/index'
  end

  get :show,:with=>[:id], :provides=>[:js] do
    rating = Rating.where(:id=>params[:id]).first
    rating.to_json
  end

  post :create, :provides=>[:js] do
    rate  = params[:rate].to_i
    model = Module.const_get params[:ratable_type].to_sym
    instance = model.where(:id=>params[:ratable_id]).first
    
    rating = current_account.ratings.create(
      :rate   =>rate,
      :ratable=>instance
    )

    if rating.valid? then
      rating.to_json
    else
      halt 400
      {:message=>"Rating Exists"}.to_json      
    end
  end

  post :update, :provides=>[:js] do
    rating = Rating.where(:id=>params[:id]).first
    if rating.blank? then
      halt 400, {:message=>"Rating(id:#{params[:id]}) not found"}
    elsif rating.account_id != current_account.id
      halt 403, {:message=>"not permitted"}
    else
      rating.rate = params[:rate].to_i
      rating.save
      rating.to_json
    end
  end

  get :config, :provides=>[:js] do
    render 'rating/config.js'
  end

end
