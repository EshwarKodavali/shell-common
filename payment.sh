#!/bin/bash

source ./common.sh
APP_NAME=payment

check_root
app_setup
python_setup
sytemd_steup
restart_setup
print_total_time
