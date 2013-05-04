ISBN_NDC_YML = File.expand_path(File.join(Padrino.root, "db", "isbn_ndc.yml"))

namespace :import do

  desc 'import ndc numbers of books'
  task :ndc => [:environment] do
    isbn_ndc = YAML.load_file ISBN_NDC_YML
    isbn_ndc.each do |data|
      item = NdlItem.where(:isbn=>data[:isbn]).first
      if item.present? then
        if item.ndc.blank?
          item.ndc = data[:ndc]
          item.save
          puts "update isbn:#{item.isbn}: add ndc #{item.ndc}"
        end
      else
        item = NdlItem.create(:isbn=>data[:isbn], :ndc=>data[:ndc])
        puts "create ndl_item(isbn:#{item.isbn} ndc:#{item.ndc})"
      end
    end
  end

end
