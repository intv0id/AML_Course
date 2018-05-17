#!/bin/bash

notebooks_path=$(find -type d | grep "^\./[0-9]-.*" | grep -v "^\./.*/.*$")

function titled_desc {
    for notebook_path in $@
    do
        notebook=$((find $notebook_path -type f -iregex .*\.ipynb; find $notebook_path -type f -iregex .*-checkpoint\.ipynb) | sort | uniq -u)
        notebook_file=$(echo $notebook | sed "s/.*\/\(.*\)$/\1/")
        description_file="$notebook_path/description.md"
        buffer_description_file="$notebook_path/buffer_description.md" 
        html_notebook_file=$(sed "s/\(.*\).ipynb/\1.html/")
        
        printf "## [$notebook_file]($html_notebook_file)\n" > $buffer_description_file
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

pandoc -o Public-visu/index.html -f markdown -t html <(cat README.md $(titled_desc $notebooks_path))
clean $notebooks_path
