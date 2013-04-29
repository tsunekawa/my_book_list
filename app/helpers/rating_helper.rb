# Helper methods defined here can be accessed in any controller or view in the application

MyBookList.helpers do
  def rating_tag(rating, opts={})
    "<span class='rating' id='rating_#{rating.id}' ratable-type='#{ rating.ratable_type }' ratable-id='#{ rating.ratable_id }' data-score='#{ rating.rate }' ></span>"
  end
end
