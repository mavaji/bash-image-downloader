#!/bin/bash

declare from_file=1
declare to_file=496
declare root_folder='x'
declare prefix='ajayeb'
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

for file_name in $(seq -f "%05g" $from_file $to_file);
do

    base_url='https://image01.cudl.lib.cam.ac.uk/content/images/MS-NN-00003-00074-000-'$file_name'_files/14/'

    path=$root_folder/$prefix'_'$file_name'_files/'

    for i in `seq 0 27`;
    do
        for j in `seq 0 37`;
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
