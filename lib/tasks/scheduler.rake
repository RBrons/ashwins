namespace :scheduler do
  desc "DELETE TransactionMain Init=true a while ago"
  task :delete_init_true => :environment do
    TransactionMain.where(init: true).where('created_at <= ?', 7.days.ago).delete_all
  end
end
