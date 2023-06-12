# Process finder
using Python scripting language write a script that will find processes in processlist such as:

```bash
/usr/bin/java -Dengine=my_engine -server -Xmx182536110080 -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps -XX:+PrintGCApplicationStoppedTime -cp /opt/myapp/conf:/opt/myapp/bin/v5.44.32/oc.jar:/opt/myapp/lib/*: Engine
```

and output the results into MySQL table containing three columns:

`engine_name` = 'my_engine'
`xmx` = 182536110080
`engine_version` = '5.44.32'

This table will be used for selects only using 'engine_name' as search filter.

(to simulate you can use C code that only sleeps:

```c
#include <unistd.h>

int main() {
	sleep(60000);
	return 0;
}
```

and then run your command like:

```bash
/usr/bin/java -Dengine=my_engine -server -Xmx182536110080 -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps -XX:+PrintGCApplicationStoppedTime -cp /opt/myapp/conf:/opt/myapp/bin/v5.44.32/oc.jar:/opt/myapp/lib/*: Engine)
```

Please include both script and CREATE TABLE statement.
