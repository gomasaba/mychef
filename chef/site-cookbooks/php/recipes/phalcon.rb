
package "gcc" do
    action :install
end
package "make" do
    action :install
end

package "libtool" do
    action :install
end


execute "cphalcon" do
    command "git clone git://github.com/phalcon/cphalcon.git ; cd cphalcon/build ; sudo ./install"
    action :run
    not_if "php -i | grep phalcon"
end

template "/etc/php.d/phalcon.ini" do
    source "phalcon.ini.erb"
    notifies :restart, 'service[httpd]'
end

=begin
execute "pear-channel-phalconphp" do
    command "pear channel-discover pear.phalconphp.com"
    action :run
    not_if "pear list-channels | grep pear.phalconphp.com"
end

execute "phalcon" do
    command "pear config-show | grep preferred_state | awk '{split($0, s, " "); print s[5]}';
    pear config-set preferred_state beta;
    pear install phalcon/Devtools"
    action :run
    not_if "which phalcon"
end
=end

execute "phalcon" do
    command "cd ~;
    git clone https://github.com/phalcon/phalcon-devtools.git;
    cd phalcon-devtools;
    ln -s ~/phalcon-devtools/phalcon.php /usr/bin/phalcon;
    chmod ugo+x /usr/bin/phalcon"
    action :run
    not_if "which phalcon"
end


