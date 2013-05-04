namespace :amazon do
  task 'cache:all' =>[:environment] do
    Book.cache_all
  end
end
