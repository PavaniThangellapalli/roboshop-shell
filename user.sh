 source common.sh
 
 print_head "Configure NodeJS Repo"
 curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
 status_check $?
 
 print_head "Install Node JS"
 yum install nodejs -y &>>${log_file}
 status_check $?
 
 print_head "Create Roboshop user"
 id roboshop &>>${log_file}
 if [ $? -ne 0 ] ; then
  useradd roboshop &>>${log_file}
 fi
 status_check $?
 
 print_head "Create application directory"
 if [ ! -d /app ] ; then
  mkdir /app &>>${log_file}
 fi
 status_check $?
 
 print_head "Delete old content"
 rm -rf /app/* &>>${log_file}
 status_check $?
 
 print_head "Downloading app content"
 curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${log_file}
 status_check $?
 cd /app 
 
 print_head "Extracting App content"
 unzip /tmp/user.zip &>>${log_file}
 status_check $?
 
 print_head "Installing Node JS dependencies"
 npm install &>>${log_file}
 status_check $?
 
 print_head "Copy systemd service file"
 cp ${code_dir}/Configs/user.service /etc/systemd/system/user.service &>>${log_file}
 status_check $?
 
 print_head "Reload systemd"
 systemctl daemon-reload &>>${log_file}
 status_check $?
 
 print_head "Enable user service"
 systemctl enable user &>>${log_file}
 status_check $?
 
 print_head "Start user service"
 systemctl restart user &>>${log_file}
 status_check $?
 
 print_head "Copy mongodb repo file"
 cp ${code_dir}/Configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
 status_check $?
 
 print_head "Install Mongodb client"
 yum install mongodb-org-shell -y &>>${log_file}
 status_check $?
 
 print_head "Load Schema"
 mongo --host mongodb.dreamhigher.online </app/schema/user.js &>>${log_file}
 status_check $?
 
 
 
 
 
 