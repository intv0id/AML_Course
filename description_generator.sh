#!/bin/bash

notebooks_path=$(find -type d | grep "^\./[0-9]-.*" | grep -v "^\./.*/.*$")

function titled_desc {
    for notebook_path in $@
    do
        notebook=$((find $notebook_path -type f -iregex .*\.ipynb; find $notebook_path -type f -iregex .*-checkpoint\.ipynb) | sort | uniq -u)
        notebook_file=$(echo $notebook | sed "s/.*\/\(.*\)$/\1/")
        description_file="$notebook_path/description.md"
        buffer_description_file="$notebook_path/buffer_description.md" 
        
        echo "## [$notebook]($notebook_file)" > $buffer_description_file
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

cat README.md $(titled_desc $notebooks_path) > Public-visu/README.md
clean $notebooks_path
