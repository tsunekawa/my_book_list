EXPORT_BOOKLIST_YML = File.expand_path(File.join(Padrino.root, "db", "export_booklist.yml"))

namespace :export do
  desc "export book lists of each accounts"
  task :book_list =>[:environment] do
    dataset = Hash.new
    Account.find_each do |account|
      ary = Array.new
      account.books.each do |book|
        ary << {
          :book_isbn    => book.isbn,
          :book_title   => book.title,
          :book_ndc     => book.ndc
        }
      end
      dataset[account.name.to_sym] = ary
    end 
    yml=YAML.dump(dataset)
    File.open(EXPORT_BOOKLIST_YML, "w") do |f|
      f.print yml
    end
    puts "exported #{dataset.keys.size} book lists!"
  end
end
