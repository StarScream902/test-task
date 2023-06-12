#!/usr/bin/env python3

import re
from datetime import datetime


stream_file = open('stream.log', 'r')
lines = stream_file.readlines()

for line in lines:
    if re.search("52=", line):
        line_ts = re.match("(\d+-\d+-\d+\s\d+:\d+:\d+\.\d+).+52=(\d+-\d+:\d+:\d+\.\d+).+", line)
        first_ts = datetime.strptime(line_ts.group(1), '%Y-%m-%d %H:%M:%S.%f')
        second_ts = datetime.strptime(line_ts.group(2), '%Y%m%d-%H:%M:%S.%f')
        delta = (first_ts - second_ts)
        if delta.total_seconds() > 0.01:
            print(line)
            print("delta is ", delta.total_seconds())

stream_file.close()
