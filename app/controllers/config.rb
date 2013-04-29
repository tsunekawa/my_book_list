MyBookList.controllers :config do
  get :index, :provides=>[:js] do
    conf = Hash.new
    conf[:rating] = {
      :create_path => url(:rating, :create, :account_id=>current_account.id),
      :update_path => url(:rating, :update, :account_id=>current_account.id),
      :starOff_path => asset_path(:image, "raty/star-off.png")
    }

    conf.to_json
  end

end
