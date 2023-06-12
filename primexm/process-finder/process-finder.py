#!/usr/bin/en python3

import psutil
import re
import mysql.connector


mydb = mysql.connector.connect(
    host="localhost",
    database="processes",
    user="processes",
    password="hyDDKkZX7Te4wixereAb"
)

mycursor = mydb.cursor()
mycursor.execute("CREATE TABLE IF NOT EXISTS processes(engine_name VARCHAR(255) PRIMARY KEY, xmx BIGINT, engine_version VARCHAR(255)) ENGINE=INNODB")


for p in psutil.process_iter():
    pstr = ' '.join(p.cmdline())
    pmatch = re.match(".+\/Telegram\/(.+)", pstr)
    if pmatch:
        proc = ["/usr/bin/java", "-Dengine=my_engine", "-server -Xmx182536110080", "-verbose:gc", "-XX:+PrintGCDetails", "-XX:+PrintGCTimeStamps", "-XX:+PrintGCDateStamps", "-XX:+PrintGCApplicationStoppedTime", "-cp /opt/myapp/conf:/opt/myapp/bin/v5.44.32/oc.jar:/opt/myapp/lib/*: Engine" ]
        procstr = ' '.join(proc)
        procvals = re.match(".+-Dengine=(\w+).+-server\s-Xmx(\d+).+v(\d+.\d+.\d+).+", procstr)
        if procvals:
            sql = "INSERT INTO processes (engine_name, xmx, engine_version) VALUES (%s, %s, %s)"
            val = ("John", "Highway 21")
            mycursor.execute(sql, procvals.groups())
            mydb.commit()


mycursor.execute("SELECT * FROM processes")

myresult = mycursor.fetchall()

for x in myresult:
    print(x)
