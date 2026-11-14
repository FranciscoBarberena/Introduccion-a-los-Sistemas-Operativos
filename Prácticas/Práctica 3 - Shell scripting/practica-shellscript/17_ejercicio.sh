for file in $(ls)
do
    if [ -f $file ]; then
	    echo $(echo "$file" | tr -d "Aa" | tr "B-Zb-z" "b-zB-Z")
    fi
done
exit 0
