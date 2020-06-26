CREATE DATABASE wordpress;
GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;
update mysql.user set plugin='mysql_native_password' where user='root';
FLUSH PRIVILEGES;
