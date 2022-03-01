#!/bin/bash

echo "Processing OPUS dictionaries..."

sort_by_freq=false
if [ "$#" -eq 2 ]; then
    if [ $2 == "true" ] || [ $2 == 1 ]; then
        sort_by_freq=true
    fi
fi
output_folder=$1
lang1="fi"
lang2="hu"
mkdir -p $output_folder 
mkdir -p $output_folder/temp
num=1
output_file=$output_folder"/opus_"$lang1"_"$lang2".tsv"
curl -s "https://opus.nlpl.eu/opusapi/?source="$lang1"&target="$lang2"&preprocessing=dic&version=latest" > $output_folder/opus.json

rm -f $output_file
for url in $(cat $output_folder/opus.json | grep -Po '"url":\K.*?[^\\]",') ; do
    file=$output_folder/temp/temp$num
    rm -f $file
    wget -qO $file.gz ${url:1:${#url}-3}
    gzip -d $file.gz
    columns=`head -1 $file | wc -w`
    if [ $columns -ne 2 ]; then
        if [ $sort_by_freq == true ]; then
            cat $file | sort -nr | cut -f1,3,4 | grep -P "^[0-9]+\s+([a-zA-ZäöüáÄÖÜÁ0-9]+\s*)+\s*([a-zA-Z0-9öüóőúűéáíÖÜÓŐÚŰÉÁÍ]+\s*)+" >> $output_file
        else
            cat $file | cut -f3-4 | sort -u | grep -P "^([a-zA-ZäöüáÄÖÜÁ0-9]+\s*)+\s*([a-zA-Z0-9öüóőúűéáíÖÜÓŐÚŰÉÁÍ]+\s*)+" >> $output_file
        fi
    else 
        if [ $sort_by_freq == false ]; then
            cat $file | sort -u | grep -P "^([a-zA-ZäöüáÄÖÜÁ0-9]+\s*)+\s*([a-zA-Z0-9öüóőúűéáíÖÜÓŐÚŰÉÁÍ]+\s*)+" >> $output_file
        fi
    fi
    num=$((num+1))
done

cat $output_file | grep -P "^\S+ \S+$" | sed "s/ /\t/g" > $output_folder/opus_temp_space_changed_to_tab.tsv
cat $output_file | grep -Pv "^\S+ \S+$" > $output_folder/opus_temp_without_space.tsv
if [ $sort_by_freq == true ]; then
    cat $output_folder/opus_temp_without_space.tsv $output_folder/opus_temp_space_changed_to_tab.tsv | sort -nr | cut -f2-3 | cat -n | sort -fuk2 | sort -nk1 | cut -f2,3  > $output_file
else
    cat $output_folder/opus_temp_without_space.tsv $output_folder/opus_temp_space_changed_to_tab.tsv | sort -u > $output_file
fi
rm -f $output_folder/opus_temp*

echo "File created: " $output_file
