.es(index=dcsid-*, timefield='@timestamp', metric='count:WT.act')
.es(offset=-4m,index=dcsid-*, timefield='@web_timestamp', metric='count:WT.act')
.es(index=dcsid-*, timefield=@timestamp, metric=max:system.network.in.bytes).derivative()
