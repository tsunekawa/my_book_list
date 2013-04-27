MyBookList.controllers :rating, :parent=>:account do

  get :index do
    logger.debug current_account
    @ratings = current_account.ratings
    render 'rating/index'
  end

  get :index,:with=>[:id], :provides=>[:js] do
    rating = Rating.where(:id=>params[:id]).first
    rating.to_json
  end

  post :index, :provides=>[:js] do
    rate  = params[:rate].to_i
    model = get_const params[:ratable_type].to_sym
    instance = model.where(:id=>params[:ratable_id]).first
    
    current_account.ratings.create(
      :rate   =>rate,
      :ratable=>instance
    )
  end

  put :index, :with=>[:id], :provides=>[:js] do
    rating = Rating.where(:id=>params[:id]).first
    raise if rating.account.id != current_account.id
    rating.rate = params[:rate].to_i
    rating.save

    rating.to_json
  end

end
