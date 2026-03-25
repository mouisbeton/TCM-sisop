#!/bin/bash

awk '{ ip_count[$1]++; status_count[$9]++ } END { 
    print "Total Request per IP:"
    for (ip in ip_count) {
        print ip, ip_count[ip]
    }
    print "\nJumlah Status Code:"
    for (status in status_count) {
        print status, status_count[status]
    }
}' access.log
