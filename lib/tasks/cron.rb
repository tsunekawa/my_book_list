namespace :amazon do
  task 'cache:all' do
    Book.cache_all
  end
end
