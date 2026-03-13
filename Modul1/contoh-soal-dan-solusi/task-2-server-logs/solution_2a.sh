#!/bin/bash
# Contoh Solusi 2a - Hitung total request per IP

awk '{print $1}' access.log | sort | uniq -c | awk '{print $2 ": " $1 " requests"}'
