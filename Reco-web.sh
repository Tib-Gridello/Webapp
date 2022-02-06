#!/bin/bash

Reconnaissance () {

        #Get param of script to use in function
        arg1=$1

        #remove https:// from url to use in host
        arg2=$(basename $arg1)

        #ffuf using raft-large-directories
        ffuf -u $arg1/FUZZ -w "/usr/share/seclists/Discovery/Web-Content/raft-large-directories.txt" -recursion -e ".bak, .zip, .bak, .sql, .zip, .xml, .old, .inc, .js, .json, .conf, .cfg, .log, .yml, .yaml, .txt, .sql, .rar, .bak-ac, .aspx, .php" -recursion-depth 2 -replay-proxy http://127.0.0.1:8080 -c -o $Full_path/ffuf-dir.txt -fs 0 -fc 404 

        #ffuf using raft-large-files
        ffuf -u $arg1/FUZZ -w "/usr/share/seclists/Discovery/Web-Content/raft-large-files.txt" -recursion -e ".bak, .zip, .bak, .sql, .zip, .xml, .old, .inc, .js, .json, .conf, .cfg, .log, .yml, .yaml, .txt, .sql, .rar, .bak-ac, .aspx, .php" -recursion-depth 2 -replay-proxy http://127.0.0.1:8080 -c -o $Full_path/ffuf-files.txt 

        #sslscan of the target
        sslscan $1 > $Full_path/sslscan-output.txt 

        #nuclei on the target
        nuclei -update 
        nuclei -u $arg1 -o $Full_path/nuclei-output

        #Get IP from URL
        ip_target=$(host $arg2 | awk '/has address/ { print $4 ; exit }')

        #nmap on IP. Careful with the flags :) -- Could have nmap on URL but not fun
        nmap -sV -A -p- $ip_target -oA $Full_path/nmap-output 
}

#Save some variable 
Base_path=~/Desktop
Folder_name=$(basename $1)
Full_path=${Base_path}/${Folder_name}

#Create folder under /home/kali/Desktop/base_name_of_target
mkdir -p $Full_path

#Run function
Reconnaissance $1
