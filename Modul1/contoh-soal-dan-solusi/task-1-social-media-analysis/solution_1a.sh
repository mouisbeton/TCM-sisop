#!/bin/bash
# Contoh Solusi 1a - Filter nama produk dengan kondisi tertentu

awk -F',' 'NR>1 && $2 ~ /2/ && $2 !~ /_/ {print $2}' products.csv | sort
