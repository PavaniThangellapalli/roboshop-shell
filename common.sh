code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head() {
    echo -e "\e[36m$1\e[0m"
}

status_check() {
    if [ $1 -eq 0 ] ; then 
        echo SUCCESS
    else
        echo FAILURE
        echo "Read the log file ${log_file} for information about error"
        exit 1
    fi
}

# Systemd Function
systemd_setup() {
    print_head "Copy systemd service file"
    cp ${code_dir}/Configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
    status_check $?
 
    print_head "Reload systemd"
    systemctl daemon-reload &>>${log_file}
    status_check $?
 
    print_head "Enable user service"
    systemctl enable ${component} &>>${log_file}
    status_check $?
 
    print_head "Start user service"
    systemctl restart ${component} &>>${log_file}
    status_check $?
}

# Schema setup Function
schema_setup() {
 
 if [ "${schema_type}" == "mongo" ] ; then
 
 print_head "Copy mongodb repo file"
 cp ${code_dir}/Configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
 status_check $?
 
 print_head "Install Mongodb client"
 yum install mongodb-org-shell -y &>>${log_file}
 status_check $?
 
 print_head "Load Schema"
 mongo --host mongodb.dreamhigher.online </app/schema/${component}.js &>>${log_file}
 status_check $?

 elif [ "${schema_type}" == "mysql" ] ; then
 
    print_head "Install MySQL Client"
    yum install mysql -y &>>${log_file}
    status_check $?
    
    print_head "Load schema"
    mysql -h mysql.dreamhigher.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql &>>${log_file}
 fi
}

app_prereq_setup() {
    
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
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
    status_check $?
    cd /app 
 
    print_head "Extracting App content"
    unzip /tmp/${component}.zip &>>${log_file}
    status_check $?
 
}

nodejs() {
 
    print_head "Configure NodeJS Repo"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
    status_check $?
 
    print_head "Install Node JS"
    yum install nodejs -y &>>${log_file}
    status_check $?
 
    app_prereq_setup
 
    print_head "Installing Node JS dependencies"
    npm install &>>${log_file}
    status_check $?

    schema_setup
 
    systemd_setup
 
}

java() {
    
    print_head "Installing Maven"
    yum install maven -y &>>${log_file}
    status_check $?
    
    app_prereq_setup
    
    print_head "Download Dependencies & Package"
    mvn clean package &>>${log_file}
    mv target/${component}-1.0.jar ${component}.jar &>>${log_file}
    status_check $?

    schema_setup

    systemd_setup

}