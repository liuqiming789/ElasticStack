# To load the dashboards for winlogbeat into Kibana, run:

    ./scripts/import_dashboards

# https://www.elastic.co/guide/en/beats/winlogbeat/5.5/index.html
# 日志
# application events
# hardware events
# security events
# system events
winlogbeat.event_logs:
  - name: Application
    ignore_older: 72h
  - name: Security
  - name: System
# output
output.elasticsearch:
  hosts: ["localhost:9200"]
  template.name: "winlogbeat"
  template.path: "winlogbeat.template.json"
  template.overwrite: false

# 启动
.\winlogbeat  -c winlogbeat.yml -e