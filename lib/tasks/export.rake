EXPORTDIR = File.expand_path(File.join(Padrino.root, "db", "dump"))
EXPORT_BOOKLIST_YML = File.expand_path(File.join(EXPORTDIR, "export_booklist.yml"))
EXPORT_RATINGS_YML = File.expand_path(File.join(EXPORTDIR, "export_ratings.yml"))

namespace :export do
  task :dir do
    mkdir EXPORTDIR unless File.exists? EXPORTDIR
  end

  desc "export book lists of each accounts"
  task :book_list =>[:environment,:dir] do
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

  desc "export each accounts' ratings"
  task :ratings =>[:environment,:dir] do
    dataset = Hash.new
    Account.find_each do |account|
      ary = Array.new
      account.ratings.each do |rating|
        ary << {
          :target => rating.ratable.name,
          :score  => rating.rate
        }
      end
      dataset[account.name.to_sym] = ary
    end
    File.open(EXPORT_RATINGS_YML, "w") do |f|
      f.print dataset.to_yaml
    end
  end

end
