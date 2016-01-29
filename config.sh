#! /bin/bash
files=("file1" "file2" "file3" "file4" "Quit")

menuitems() {
    echo "Avaliable options:"
    for i in ${!files[@]}; do
        printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${files[i]}"
    done
    [[ "$msg" ]] && echo "$msg"; :
}

prompt="Enter an option (enter again to uncheck, press RETURN when done): "
while menuitems && read -rp "$prompt" -n 1 num && [[ "$num" ]]; do
    [[ "$num" != *[![:digit:]]* ]] && (( num > 0 && num <= ${#files[@]} )) || {
        msg="Invalid option: $num"; continue
    }
    if [ $num == ${#files[@]} ];then
      exit
    fi
    ((num--)); msg="${files[num]} was ${choices[num]:+un-}selected"
    [[ "${choices[num]}" ]] && choices[num]="" || choices[num]="x"
done

printf "You selected"; msg=" nothing"
for i in ${!files[@]}; do
    [[ "${choices[i]}" ]] && { printf " %s" "${files[i]}"; msg=""; }
done
echo "$msg"
