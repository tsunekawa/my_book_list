# Helper methods defined here can be accessed in any controller or view in the application

MyBookList.helpers do
  def rating_box_tag(hash={})
    account = hash[:account]
    ratable = hash[:ratable]
    rating  = account.rating_of ratable
    partial "layouts/rating-box", :locals=>{:account=>hash[:account], :rating=>rating}
  end
end
