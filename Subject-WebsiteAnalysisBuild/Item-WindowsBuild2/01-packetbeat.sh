Edit the packetbeat.yml configuration file
Start the daemon by running 
sudo ./packetbeat -e -c packetbeat.yml

# step 2
# 查看device
.\packetbeat.exe -devices
0: {} (VMware Virtual Ethernet Adapter) (192.168.13.1)
1: {} (Microsoft) (192.168.1.11)
2: {} (Sangfor SSL VPN CS Support System VNIC) (0.0.0.0)
3: {} (VMware Virtual Ethernet Adapter) (192.168.139.1)
4: {} (Microsoft) (0.0.0.0)

packetbeat.interfaces.device: 1

# step 3
output.elasticsearch:
  hosts: ["localhost:9200"]
  template.name: "packetbeat"
  template.path: "packetbeat.template.json"
  template.overwrite: false

# step 4
.\packetbeat -c .\packetbeat.yml -e

# step 5
 To load the dashboards for packetbeat into Kibana, run:

.\scripts\import_dashboards

############################
# 问题1：由于找不到wpcap.dll
安装Win10Pcap-v10.2-5002.msi
############################


# step 6
http://localhost:9200/_cat/indices?v
yellow open   packetbeat-2017.08.05 M0X-G0fsTkKIEnpaWLZVpw   5   1       2754            0      1.3mb          1.3mb
