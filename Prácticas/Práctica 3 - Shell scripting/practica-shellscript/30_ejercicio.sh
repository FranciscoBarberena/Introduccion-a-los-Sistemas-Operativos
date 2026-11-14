
initialize(){
	if [ $# -ne 0 ]; then
	        return 1
	fi
	conjunto=()
	return 0
}

initialize_with(){
	if [ $# -eq 0 ]; then
                return 1
        fi
	initialize
	for parametro in "$@"; do
		add "$parametro"
	done
	return 0
}

add(){
	if [ $# -ne 1 ]; then
		return 1
	fi
	local pos
	pos=$(contains "$1")
	if [ $? -ne 0 ]; then
		local tamanio="${#conjunto[*]}"
		conjunto[tamanio]="$1"
		return 0
	fi
	return 2
}

remove(){
	if [ $# -eq 0 ]; then
                return 1
        fi
	local pos
	local retorno=2
	for parametro in "$@"; do		
		pos=$(contains "$parametro")
		if [ $? -eq 0 ]; then
               		unset conjunto[pos]
			conjunto=("${conjunto[@]}")
			retorno=0
        	fi
	done
        return $retorno

}

contains(){
	if [ $# -ne 1 ]; then
                return 1
        fi
	local i=0
	for item in "${conjunto[@]}"; do
		if [ "$item" = "$1" ]; then
			echo "$i"
			return 0
		fi
		let i++
	done
	return 1
}

print(){
	if [ $# -ne 0 ]; then
                return 1
        fi
	for item in "${conjunto[@]}"; do
		echo "$item"
	done
	return 0
}

print_sorted(){
	if [ $# -ne 0 ]; then
                return 1
        fi
	print | sort
}
