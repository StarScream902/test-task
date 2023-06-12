# Scenario 1
Please write a simple CLI application in the programming language of your choice

that does the following:
- Print the numbers from 1 to 10 in random order to the terminal.
- Please provide a README that explains in detail how to run the program on

MacOS and Linux.

## How to run the programm
Of course you have to have Python3 being installed on your device. If not, follow the [link](https://www.python.org/downloads/) and install it.

Execute the following command in terminal, opened in the directory where this script located
```bash
python3 ./rand.py
```
---
# Scenario 2
Imagine a server with the following specs:
- 4 times Intel(R) Xeon(R) CPU E7-4830 v4 @ 2.00GHz
- 64GB of ram
- 2 TB HDD disk space
- 2 x 10Gbit/s nics

The server is used for SSL offloading and proxies around 25000 requests per second. Please let us know which metrics are interesting to monitor in that specific case and how would you do that? What are the challenges of monitoring this?

## Solution
We have a lot of instruments to organize monitoring, such as:
- Prometheus
- Zabbix
- Datadog
- New Relic

### How would I organize monitoring
Easiest way for me arrange this monitoring via prometheus, because, if we already have Prometheus server, we just have to install a couple of prometheus exporters and all of this will work.

First of all I'd install node-exporter, which would collect the basic host metrics such as: CPU, Memory, Disk, Network

If we use this host for SSL offloading and requests proxying, it means, that we use some server for handling them. Most likely it is NGinx and for nginx we have already-written exporter where and collect metrics from it

Besides, we can implement logs-based monitoring and create graphics by logs

### which metrics are interesting
In this case I would pay attention more on these metrics:
- Network I/O
- CPU load
- nginx requests per second
- response time
- active connections
- Waiting requests
- request_time - upstream_response_time (from logs, we can understand how much time request was handled by NGinx server)
