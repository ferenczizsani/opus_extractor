#!/bin/bash

echo "Processing OPUS dictionaries..."

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
    #TODO ne csak egytagu szavakat tartsunk meg itt a ket grep-ben
    if [ $columns -ne 2 ]; then
        cat $file | cut -f3-4 | sort -u | grep -P "^([a-zA-ZäöüáÄÖÜÁ0-9]+\s*)+\s*([a-zA-Z0-9öüóőúűéáíÖÜÓŐÚŰÉÁÍ]+\s*)+" >> $output_file
    else 
        cat $file | sort -u | grep -P "^([a-zA-ZäöüáÄÖÜÁ0-9]+\s*)+\s*([a-zA-Z0-9öüóőúűéáíÖÜÓŐÚŰÉÁÍ]+\s*)+" >> $output_file
    fi
    num=$((num+1))
done

cat $output_file | grep -P "^\S+ \S+$" | sed "s/ /\t/g" > $output_folder/opus_temp_space_changed_to_tab.tsv
cat $output_file | grep -Pv "^\S+ \S+$" > $output_folder/opus_temp_without_space.tsv
cat $output_folder/opus_temp_without_space.tsv $output_folder/opus_temp_space_changed_to_tab.tsv | sort -u > $output_file
rm -f $output_folder/opus_temp*

echo "File created: " $output_file
