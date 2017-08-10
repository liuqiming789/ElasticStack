# 192.168.11.73/74/75/76/77配置互信
# elk用户:/app/elk/.ssh
# 发送所有shell
ssh-keygen -t rsa
cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys2_`hostname`
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*

#除了192.168.11.73, 单个节点执行
scp ~/.ssh/authorized_keys2_`hostname` 192.168.11.73:~/.ssh/

#192.168.11.73执行
cd ~/.ssh/
cat authorized_keys2_bjxhm-hadoopelk-73 >> authorized_keys
cat authorized_keys2_bjxhm-hadoopelk-74 >> authorized_keys
cat authorized_keys2_bjxhm-hadoopelk-75 >> authorized_keys
cat authorized_keys2_bjxhm-hadoopelk-76 >> authorized_keys
cat authorized_keys2_bjxhm-hadoopelk-77 >> authorized_keys

#复制到其他节点
scp ~/.ssh/authorized_keys 192.168.11.74:~/.ssh/
scp ~/.ssh/authorized_keys 192.168.11.75:~/.ssh/
scp ~/.ssh/authorized_keys 192.168.11.76:~/.ssh/
scp ~/.ssh/authorized_keys 192.168.11.77:~/.ssh/

##每个节点执行测试
ssh 192.168.11.73 'uptime'
ssh 192.168.11.74 'uptime'
ssh 192.168.11.75 'uptime'
ssh 192.168.11.76 'uptime'
ssh 192.168.11.77 'uptime'
