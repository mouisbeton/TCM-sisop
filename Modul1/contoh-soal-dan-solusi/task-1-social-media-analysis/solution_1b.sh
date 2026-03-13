#!/bin/bash
# Contoh Solusi 1b - Hitung total stock per kategori

awk -F',' 'NR>1 {stock[$5]+=$4} END {for(cat in stock) print cat ": " stock[cat]}' products.csv
