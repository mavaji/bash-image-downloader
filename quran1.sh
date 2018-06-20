#!/bin/bash

declare from_file=1
declare to_file=1
declare root_folder='x'
declare prefix='quran'
declare size=40

function count() {
    ls -l $1/*.jpg | wc -l
}

function sqrt() {
    echo "sqrt($1)" | bc
}

function validate_url() {
    if [[ `wget -S --spider $1 2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then
        echo "true";
    fi
}

function column_file_names() {
    s=''
    for k in `seq 0 $size`;
    do
        s=$s$path$1'_'$k'.jpg '
    done
    echo $s
}

function row_file_names() {
    s=''
    for k in `seq 0 $size`;
    do
        s=$s$path$k'.jpg '
    done
    echo $s
}

for file_name in $(seq $from_file $to_file);
do

    base_url='https://www.wdl.org/media/2422/service/dzi/1430161216/1/'$file_name'_files/13/'

    path=$root_folder/$prefix'_'$file_name'_files/'

    for i in `seq 0 15`;
    do
        for j in `seq 0 19`;
        do
            url=$base_url$i'_'$j'.jpg'
            if [ $(validate_url $url -eq "true") ]
            then
                wget -P $path $url
            fi
        done

    done

    c=$(count $path)
    size=$(sqrt $c) - 1

    for i in `seq 0 $size`;
    do
        result=$(column_file_names $i)

        convert -append $result $path/$i.jpg
    done

    result=$(row_file_names)
    convert +append $result $root_folder/$prefix'_'$file_name.jpg
done
