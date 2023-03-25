 source common.sh
 
 print_head "Configure NodeJS Repo"
 curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
 status_check $?
 
 print_head "Install Node JS"
 yum install nodejs -y &>>${log_file}
 status_check $?
 
 print_head "Create Roboshop user"
 useradd roboshop &>>${log_file}
 status_check $?
 
 print_head "Create application directory"
 mkdir /app &>>${log_file}
 status_check $?
 
 print_head "Delete old content"
 rm -rf /app/* &>>${log_file}
 status_check $?
 
 print_head "Downloading app content"
 curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
 status_check $?
 cd /app 
 
 print_head "Extracting App content"
 unzip /tmp/catalogue.zip &>>${log_file}
 status_check $?
 
 print_head "Installing Node JS dependencies"
 npm install &>>${log_file}
 status_check $?
 
 print_head "Copy systemd service file"
 cp ${code_dir}/Configs/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}
 status_check $?
 
 print_head "Reload systemd"
 systemctl daemon-reload &>>${log_file}
 status_check $?
 
 print_head "Enable catalogue service"
 systemctl enable catalogue &>>${log_file}
 status_check $?
 
 print_head "Start catalogue service"
 systemctl restart catalogue &>>${log_file}
 status_check $?
 
 print_head "Copy mongodb repo file"
 cp ${code_dir}/Configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
 status_check $?
 
 print_head "Install Mongodb client"
 yum install mongodb-org-shell -y &>>${log_file}
 status_check $?
 
 print_head "Load Schema"
 mongo --host mongodb.dreamhigher.online </app/schema/catalogue.js &>>${log_file}
 status_check $?
 
 
 
 
 
 