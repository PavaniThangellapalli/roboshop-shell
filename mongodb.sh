source common.sh

print_head "setup mongodb repository"
cp Configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

print_head "Install Mongodb"
yum install mongodb-org -y &>>${log_file}

print_head "Enable Mongodb"
systemctl enable mongod &>>${log_file}

print_head "Start Mongodb"
systemctl start mongod &>>${log_file}

# Update file /etc/mongod.conf from 127.0.0.1 with 0.0.0.0