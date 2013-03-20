# Helper methods defined here can be accessed in any controller or view in the application

MyBookList.helpers do
  # def simple_helper_method
  #  ...
  # end
  def book_image_for(book)
    "<img src='#{book.medium_image[:url]}' width='#{book.medium_image[:width]}' height='#{book.medium_image[:height]}' />"
  end
end
