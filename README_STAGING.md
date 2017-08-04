
Please try the following steps to deploy on Linode Server:

    $ ssh developer@96.126.127.130
    $ cd /var/App/dvno-messenger-staging/
    $ git status (commit)
    $ git commit -am "changes at server" (if require)

    $ git pull 'http git-repository address' like: https://prororgeek@bitbucket.org/prororgeek/dvno-messenger-staging.git (solve git conflict if any)

    $ bundle install && bundle exec rake db:migrate RAILS_ENV=production && rm -f -r ./public/assets/* && bundle exec rake assets:precompile RAILS_ENV=production && sudo service nginx restart

rename key_and_scope.rb.example as 1key_and_scope.rb in development


