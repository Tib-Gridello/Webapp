#!/bin/bash

Reconnaissance () {

        #ffuf using raft-large-directories
        arg1=$1
        ffuf -u $arg1/FUZZ -w "/usr/share/seclists/Discovery/Web-Content/raft-large-directories.txt" -recursion -e ".bak, .zip, .bak, .sql, .zip, .xml, .old, .inc, .js, .json, .conf, .cfg, .log, .yml, .yaml, .txt, .sql, .rar, .bak-ac, .aspx, .php" -recursion-depth 2 -replay-proxy http://127.0.0.1:8080 -c -o $Full_path/ffuf-dir.txt  

        #ffuf using raft-large-files
        ffuf -u $arg1/FUZZ -w "/usr/share/seclists/Discovery/Web-Content/raft-large-files.txt" -recursion -e ".bak, .zip, .bak, .sql, .zip, .xml, .old, .inc, .js, .json, .conf, .cfg, .log, .yml, .yaml, .txt, .sql, .rar, .bak-ac, .aspx, .php" -recursion-depth 2 -replay-proxy http://127.0.0.1:8080 -c -o $Full_path/ffuf-files.txt 

        #sslscan of the target
        sslscan $1 > $Full_path/sslscan-output.txt 

        #nuclei on the target
        nuclei -update 
        nuclei $arg1 -o $Full_path/nuclei-output
}

Base_path=~/Desktop
Folder_name=$(basename $1)
Full_path=${Base_path}/${Folder_name}

if [ -d "$DIR" ]; then
        echo "fdppppp"$1
        Reconnaissance $1
else 
        mkdir -p $Full_path
        echo "fdppppp2" $1
        Reconnaissance $1
fi
