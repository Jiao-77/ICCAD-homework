#!/bin/bash

hello_count=0  # Counter for the number of times "Hello World!" is printed

while true; do
    # Display the menu
    echo "1. Print a Hello World!"
    echo "2. Report how many times the script has printed Hello World! already"
    echo "3. Show all files under your home in long format, but any line containing file name beginning with 'h' must be in yellow color"
    echo "4. Input a name, if the file exists and is executable, show its first 16 bytes in hexadecimal format"
    echo "5. Input a name, if the file exists and is executable, find all other files in the same directory with the same 16 bytes header"
    echo "6. Let '/usr/bin/ftp' visit alpha.gnu.org, and report what directories in '/gnu' have not changed after 2005"
    echo "q. Quit"
    read -p "Choose an option: " choice

    case $choice in
        1) 
            echo "Hello World!"
            ((hello_count++))
            ;;
        2) 
            echo "The script has printed Hello World! $hello_count times."
            ;;
        3) 
            echo "Showing all files under your home directory in long format:"
            find . -type f -exec ls -l {} + | awk -F '/' '{if ($NF ~ /^h/) print "\033[1;33m"$0"\033[0m"; else print $0}'
            ;;
        4) 
            read -p "Enter a file name: " filename
            if [[ -x "$filename" && -f "$filename" ]]; then
                echo "First 16 bytes of $filename in hexadecimal:"
                head -c 16 "$filename" | od -t x1
            else
                echo "File does not exist or is not executable."
            fi
            ;;
        5) 
            read -p "Enter a file name: " filename
            if [[ -x "$filename" && -f "$filename" ]]; then
                header=$(head -c 16 "$filename" | od -t x1 | awk '{print $2 $3 $4 $5 $6 $7 $8 $9}')
                dir=$(dirname "$filename")
                echo "Files in the same directory with the same 16 bytes header:"
                for file in "$dir"/*; do
                    if [[ -f "$file" && -x "$file" ]]; then
                        file_header=$(head -c 16 "$file" | od -t x1 | awk '{print $2 $3 $4 $5 $6 $7 $8 $9}')
                        if [[ "$file_header" == "$header" ]]; then
                            echo "$file"
                        fi
                    fi
                done
            else
                echo "File does not exist or is not executable."
            fi
            ;;
        6) 
            echo "Checking '/gnu' directories that have not changed after 2005:"
            /usr/bin/ftp -n << EOF > ftp_output.txt
open alpha.gnu.org
user anonymous anonymous@example.com
cd /gnu
ls
quit
EOF

            echo "Directories not changed since 2005:"
	    awk '{if ($8 < 2005 && $8 ~ /^[0-9]{4}/) print $NF}' ftp_output.txt
	    ;;
        q)
            echo "Exiting."
            break
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
   esac
done

