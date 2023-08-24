def test_mysql_is_installed(host):
    mysql = host.package("mysql-server")
    assert mysql.is_installed

def test_mysql_running_and_enabled(host):
    mysql = host.service("mysql")
    assert mysql.is_running
    assert mysql.is_enabled

def test_mysql_port_is_listening(host):
    socket = host.socket("tcp://3306")
    assert socket.is_listening

def test_mysql_user_exists(host):
    user = host.user("mysql")
    assert user.exists
    assert user.shell == "/usr/sbin/nologin"

def test_mysql_database_exists(host):
    cmd = host.run("echo 'SHOW DATABASES;' | mysql -u root -ppassword")
    assert "your_database_name" in cmd.stdout

def test_mysql_config_file(host):
    config_file = host.file("/etc/mysql/my.cnf")
    assert config_file.exists
    assert config_file.user == "mysql"
    assert config_file.group == "mysql"

def test_mysql_log_files(host):
    logs = ["error.log", "access.log"]
    for log in logs:
        log_file = host.file(f"/var/log/mysql/{log}")
        assert log_file.exists


def test_root_login_is_disabled(host):
    cmd = host.run("echo 'SELECT user,host FROM mysql.user;' | mysql -u root -ppassword")
    assert "root@%" not in cmd.stdout

def test_firewall_is_active(host):
    firewall = host.service("ufw")
    assert firewall.is_running
    assert firewall.is_enabled