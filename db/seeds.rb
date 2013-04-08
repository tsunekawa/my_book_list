# Seed add you the ability to populate your db.
# We provide you a basic shell for interaction with the end user.
# So try some code like below:
#
#   name = shell.ask("What's your name?")
#   shell.say name
#

if Account.count<=0 then
  email     = shell.ask "Which email do you want use for logging into admin?"
  password  = shell.ask "Tell me the password to use:"

  shell.say ""

  account = Account.create(:email => email, :name => "Foo", :surname => "Bar", :password => password, :password_confirmation => password, :role => "admin")

  if account.valid?
    shell.say "================================================================="
    shell.say "Account has been successfully created, now you can login with:"
    shell.say "================================================================="
    shell.say "   email: #{email}"
    shell.say "   password: #{password}"
    shell.say "================================================================="
  else
    shell.say "Sorry but some thing went wrong!"
    shell.say ""
    account.errors.full_messages.each { |m| shell.say "   - #{m}" }
  end

  shell.say ""
else
  shell.say "admin account has already been created." 
end

reg   = /---\n((?:.|\n)*)\n---/
pages = Array.new
Dir.glob(File.join(File.dirname(__FILE__),"pages","*.md")) do |path|
  str = File.read(path)
  header = YAML.load(str.scan(reg).first.try(:first))
  body   = str.gsub(reg,"")

  if Page.where(:slag=>header[:slag]).first.blank? then
    data = header.dup
    data[:content] = body
    pages << Page.create(data)
    shell.say("page:#{header[:title]} was created.")
  else
    shell.say("page:#{header[:title]} has been already created.")
  end
end

shell.say "create #{pages.count} pages"
