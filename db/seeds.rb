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

pages_yml = YAML.load_file(File.join(File.dirname(__FILE__),"pages.yml"))
pages     = pages_yml.inject(Array.new) do |list,data|
  if Page.where(:slag=>data[:slag]).first.blank? then
    list << Page.create(data)
    shell.say("page:#{data[:title]} was created.")
  else
    shell.say("page:#{data[:title]} has been already created.")
  end
  list
end

shell.say "create #{pages.count} pages"
