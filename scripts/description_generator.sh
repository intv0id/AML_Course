#!/bin/bash

notebooks_path=$(find -type d | grep "^\./[0-9]-.*" | grep -v "^\./.*/.*$")

function titled_desc {
    for notebook_path in $@
    do
        notebook=$((find $notebook_path -type f -iregex .*\.ipynb; find $notebook_path -type f -iregex .*-checkpoint\.ipynb) | sort | uniq -u)
        notebook_file=$(echo $notebook | sed "s/.*\/\(.*\)$/\1/")
        description_file="$notebook_path/description.md"
        buffer_description_file="$notebook_path/buffer_description.md"
        notebook_file_without_ext=$(echo $notebook_file | sed "s/\(.*\).ipynb/\1/")
        html_notebook_file=$(echo $notebook_file | sed "s/\(.*\).ipynb/\1.html/")
       

        echo -e "\n## [$notebook_file_without_ext]($html_notebook_file)\n" > $buffer_description_file
        cat $description_file >> $buffer_description_file

        echo $buffer_description_file
    done
}

function clean {
    for notebook_path in $@
    do
        rm $notebook_path/buffer_description.md
    done
}

cat README.md $(titled_desc $notebooks_path) | grip --title="Machine Learning Labs" --export - > ./Public-visu/index.html
clean $notebooks_path
