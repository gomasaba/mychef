service "postgresql-9.2" do
  supports :status => true, :restart => true, :reload => true
  action :start
end

include_recipe 'database::postgresql'
postgresql_connection_info = {
    :host     => "127.0.0.1",
    :port     => node['postgresql']['config']['port'],
    :username => 'postgres',
    :password => node['postgresql']['password']['postgres']
}

database 'www' do
  connection postgresql_connection_info
  provider Chef::Provider::Database::Postgresql
  action :create
end

database 'develop' do
  connection postgresql_connection_info
  provider Chef::Provider::Database::Postgresql
  action :create
end

execute "create-user" do
    user "postgres"
    command "createuser -s www"
    not_if "psql -U postgres -c \"select * from pg_catalog.pg_user where usename='www'\" | grep -c www"
end
execute "alter-user" do
    user "postgres"
    command "psql -U postgres -c \"ALTER USER www WITH PASSWORD 'www'\""
    not_if "psql -U postgres -c \"select * from pg_catalog.pg_user where usename='www'\" | grep -c www"
end

