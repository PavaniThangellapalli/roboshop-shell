source common.sh

roboshop_app_password=$1
if [ -z "${roboshop_app_password}" ] ; then
    echo -e "\e[31mMissing RabbitMQ app password argument\e[0m"
    exit 1
fi

print_head "Setup Erlang repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${log_file}
status_check $?

print_head "Setup RabbitMQ repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${log_file}
status_check $?

print_head "Install Erlang & RabbitMQ"
yum install rabbitmq-server erlang -y &>>${log_file}
status_check $?

print_head "Enable RabbitMQ service"
systemctl enable rabbitmq-server &>>${log_file}
status_check $?

print_head "Start RabbitMQ service"
systemctl restart rabbitmq-server &>>${log_file}
status_check $?

print_head "Add application user"
rabbitmqctl list_users | grep roboshop &>>${log_file}
if [ $? -ne 0 ] ; then
    rabbitmqctl add_user roboshop ${roboshop_app_password} &>>${log_file}
fi
status_check $?

print_head "Configure permissions for App user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
status_check $?