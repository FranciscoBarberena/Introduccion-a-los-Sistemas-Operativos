for file in $(ls)
do
    if [ -f $file ]; then
	    echo $(echo "$file" | tr "A-Za-z" "a-zA-Z")
    fi
done
exit 0
