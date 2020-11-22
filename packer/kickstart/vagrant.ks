#url --url http://mirror.centos.org/centos/8.2.2004/BaseOS/x86_64/os/ 
url --mirrorlist=http://mirrorlist.centos.org/?release=8&arch=x86_64&repo=BaseOS&infra=$infra

#cmdline
text

#eula --agreed
firstboot --disabled

#cdrom

firewall --enabled --ssh

keyboard us
lang en_US.UTF-8

rootpw vagrant

skipx

timezone UTC

user --name=vagrant --password=vagrant

network --onboot yes --bootproto=dhcp --device=eth0 --activate --noipv6 --hostname=less1_vm


ignoredisk --only-use=sda
zerombr
clearpart --all --initlabel
autopart --type=plain --nohome --noboot 

bootloader --location=mbr --boot-drive=sda --append="ipv6.disable=1 net.ifnames=0 biosdevname=0"


logging --level=info

%packages
@core
%end

reboot

%post --log=/root/post_install.log

# Add vagrant to sudoers
cat > /etc/sudoers.d/vagrant << EOF_sudoers_vagrant
vagrant        ALL=(ALL)       NOPASSWD: ALL
EOF_sudoers_vagrant

/bin/chmod 0440 /etc/sudoers.d/vagrant
/bin/sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

# Fix sshd config for CentOS 7 1611 (reboot issue)
cat << EOF_sshd_config >> /etc/ssh/sshd_config

TCPKeepAlive yes
ClientAliveInterval 0
ClientAliveCountMax 5

UseDNS no
UsePAM no
GSSAPIAuthentication no
ChallengeResponseAuthentication no

EOF_sshd_config

%end
