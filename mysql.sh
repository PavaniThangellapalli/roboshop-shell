source common.sh

mysql_root_password=$1
if [ -z "${mysql_root_password}" ] ; then
    echo -e "\e[31mMissing MySQL Root Password argument\e[0m"
    exit 1
fi

print_head "Disabling MySQL version 8"
dnf module disable mysql -y &>>${log_file}
status_check $?

print_head "Copy and setup MySQL version 5.7 repo file"
cp ${code_dir}/Configs/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}
status_check $?

print_head "Installing MySQL server"
yum install mysql-community-server -y &>>${log_file}
status_check $?

print_head "Enable MySQL service"
systemctl enable mysqld &>>${log_file}
status_check $?

print_head "Start MySQL service"
systemctl restart mysqld &>>${log_file}
status_check $?

print_head "Set Password"
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log_file}
status_check $?
