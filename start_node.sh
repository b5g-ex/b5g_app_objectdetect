#!/bin/sh

#
# set variables
#
: ${NODE_NAME:="b5g_app_objectdetect"}
: ${NODE_IPADDR:="127.0.0.1"}
: ${COOKIE:="idkp"}
: ${DEFAULT_BACKEND_SERVER:="{:yolov3_wrapper_ex, :\"yolov3_wrapper_ex@127.0.0.1\"}"}
: ${USE_GIOCCI:="false"}

#
# start node
#
echo "exec:
DEFAULT_BACKEND_SERVER=\"${DEFAULT_BACKEND_SERVER}\" iex \
--name \"${NODE_NAME}@${NODE_IPADDR}\" \
--cookie \"${COOKIE}\" \
-S mix phx.server
"

DEFAULT_BACKEND_SERVER="${DEFAULT_BACKEND_SERVER}" iex \
  --name "${NODE_NAME}@${NODE_IPADDR}" \
  --cookie "${COOKIE}" \
  -S mix phx.server
