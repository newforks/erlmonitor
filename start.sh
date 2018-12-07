#!/bin/sh
cd `dirname $0`

#must >1024000
#ulimit -n 1024000
# +A 8
exec erl \
-name erlmonitor@127.0.0.1 \
-pa ./_build/default/lib/*/ebin \
-config ./config/sys.config \
-s reloader \
-s erlmonitor \
-setcookie 1234567890


