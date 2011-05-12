set :domain, "www.yourgarageonline.com"
set :user, "nobody"
set :group, "nobody"

set :application, "ygo"
set :repository,  "http://example.com/alloy/ygo/trunk"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/apps/#{application}"
set :deploy_via, :export

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, domain
role :web, domain
role :db,  domain, :primary => true

set :mongrel_config, "/etc/mongrel_cluster/#{application}.yml"

ssh_options[:paranoid] = false


# 4/26/08 -- deprecated with switch to mod_rails
# namespace :deploy do

  # task :restart do
  #   sudo "mongrel_rails cluster::restart --clean -C #{mongrel_config}"
  # end
  #
  # task :start do
  #   sudo "mongrel_rails cluster::start --clean -C #{mongrel_config}"
  # end
  #
  # task :stop do
  #   sudo "mongrel_rails cluster::stop --clean -C #{mongrel_config}"
  # end
# end

namespace :deploy do
  task :start, :roles => :app do
  end

  task :stop, :roles => :app do
  end

  task :restart, :roles => :app do
    sudo "touch #{release_path}/tmp/restart.txt"
  end

  task :after_update_code, :roles => :app do
    sudo "rm -rf #{release_path}/public/.htaccess"
  end
end

after :deploy, :set_permissions

task :set_permissions do
  sudo "chmod 0775 #{release_path}/public"
end

# NGINX Recipes

# task :start_nginx do
#   sudo '/etc/init.d/nginx start'
# end
#
# task :restart_nginx do
#   sudo '/etc/init.d/nginx restart'
# end
#
# task :stop_nginx do
#   sudo '/etc/init.d/nginx stop'
# end

task :create_database_yml do
  run "cp #{release_path}/config/database.yml.production #{release_path}/config/database.yml"
end

# here is my section to tie this all together and make it as easy as three cap instructions to setup a new server
task :deploy_first_time do
  setup
  deploy
  create_database_yml
  setup_mysql
  migrate
  # configure_mongrel_cluster
  # configure_nginx
  # restart_mongrel_cluster
  # start_nginx
end

# overwrite the deprec read_config task so that it grabs the right config
def read_config
  db_config = YAML.load_file('config/database.yml.production')
  set :db_user, db_config[rails_env]["username"]
  set :db_password, db_config[rails_env]["password"]
  set :db_name, db_config[rails_env]["database"]
end