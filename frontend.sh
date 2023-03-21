source common.sh

print_head "Installing nginx"
yum install nginx -y &>>${log_file}

print_head "Removing Old Content"
rm -rf /usr/share/nginx/html/* &>>${log_file}

print_head "Downloading Frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}

print_head "Extracting Downloaded Frontend"
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>${log_file}

print_head "Copying nginx config for Roboshop"
cp ${code_dir}/Configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}

print_head "Enabling nginx"
systemctl enable nginx &>>${log_file}

print_head "Starting nginx"
systemctl restart nginx &>>${log_file}


# Roboshop config is not copied => Resolved
# If any command is errored or failed,we need to stop the script 
# Status of command needs to be printed
