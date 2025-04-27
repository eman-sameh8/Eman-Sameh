#!/bin/bash


usage() {
    echo "Usage: $0 [options] <search_string> <file>"
    echo "Options:"
    echo "  -n    Show line numbers"
    echo "  -v    Invert match (show lines that do NOT match)"
    echo "  --help Show this help message"
}


if [[ $# -lt 1 ]]; then
    usage
    exit 1
fi


if [[ "$1" == "--help" ]]; then
    usage
    exit 0
fi


show_line_numbers=false
invert_match=false


while [[ "$1" == -* ]]; do
    case "$1" in
        -n) show_line_numbers=true ;;
        -v) invert_match=true ;;
        -vn|-nv) show_line_numbers=true; invert_match=true ;;
        *) 
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
    shift
done


search_string="$1"
file="$2"


if [[ -z "$search_string" || -z "$file" ]]; then
    echo "Error: Missing search string or file."
    usage
    exit 1
fi


if [[ ! -f "$file" ]]; then
    echo "Error: File '$file' not found."
    exit 1
fi


line_number=0
while IFS= read -r line; do
    ((line_number++))
    
   
    if echo "$line" | grep -iq "$search_string"; then
        match=true
    else
        match=false
    fi

   
    if $invert_match; then
        match=$(! $match && echo true || echo false)
    fi

   
    if [[ "$match" == "true" ]]; then
        if $show_line_numbers; then
            echo "${line_number}:$line"
        else
            echo "$line"
        fi
    fi

done < "$file"
