job_type :padrino_rake, 'cd :path && padrino rake :task -e :environment >> log/cron.log'

every :hour do
  padrino_rake 'amazon:cache:all'
end
