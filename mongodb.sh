source common.sh

print_head "setup mongodb repository"
cp ${code_dir}/Configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "Install Mongodb"
yum install mongodb-org -y &>>${log_file}
status_check $?

print_head "Enable Mongodb"
systemctl enable mongod &>>${log_file}
status_check $?

print_head "Update MongoDB listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log_file}
status_check $?

print_head "Start Mongodb"
systemctl restart mongod &>>${log_file}
status_check $?

# Update file /etc/mongod.conf from 127.0.0.1 with 0.0.0.0