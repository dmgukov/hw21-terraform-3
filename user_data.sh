#!/bin/sh
cat << "HERE" > /etc/update-motd.d/30-banner
#!/bin/sh
cat << "EOF"
           __   _,--="=--,_   __
          /  \."    .-.    "./  \
         /  ,/  _   : :   _  \/` \
         \  `| /o\  :_:  /o\ |\__/
          `-'| :="~` _ `~"=: |
             \`     (_)     `/
      .-"-.   \      |      /   .-"-.
.----{     }--|  /,.-'-.,\  |--{     }----.
 )   (_)_)_)  \_/`~-===-~`\_/  (_(_(_)   (
(             Hillel Homework 21          )
 )             by Dmytro Gukov            (
'-----------------------------------------'
EOF
HERE
update-motd --force
yum install -y docker
usermod -aG docker ec2-user
systemctl enable docker
systemctl start docker
docker run -d --name nginx -p 8080:80 nginx:alpine