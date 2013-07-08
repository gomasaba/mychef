include_recipe 'database::mysql'

mysql_connection_info = {
    :host => "localhost",
    :username => 'root',
    :password => node['mysql']['server_root_password']
}

mysql_database "develop" do
    connection mysql_connection_info
    action :create
end
mysql_database "develop_test" do
    connection mysql_connection_info
    action :create
end

# mysql_database_user "www" do
#     connection mysql_connection_info
#     password "www"
#     host "*"
#     database_name "develop"
#     privileges [:all]
#     action [:create, :grant,:drop]
# end
# mysql_database_user "www" do
#     connection mysql_connection_info
#     password "www"
#     host "*"
#     database_name "develop_test"
#     privileges [:all]
#     action [:create, :grant,:drop]
# end
