# Helper methods defined here can be accessed in any controller or view in the application

MyBookList.helpers do
  # def simple_helper_method
  #  ...
  # end
  def book_image_for(book)
    begin
    "<img src='#{book.medium_image[:url]}' width='#{book.medium_image[:width]}' height='#{book.medium_image[:height]}' />"
    rescue => ex
    logger.error ex
    "<img alt='image not found' width='#{book.medium_image[:width]}' height='#{book.medium_image[:height]}' />"
    end
  end

  def permit_access?
    logged_in? and (current_account.role.to_sym == :admin or current_account.id == @account.id)
  end
end
