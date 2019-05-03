count=1;
for quartern in `grep -no "[^ :]*{[^ ]\+}" todo.txt|tr "." "-"|awk -F"[{-}]" '{printf("%s%s\n",$1,$2)}'`;do 
    item=`echo $quartern|cut -d ":" -f1`
    quarter=`echo $quartern|cut -d ":" -f2`
    date1=`echo $quarter|sed 's/\(.*\)00-00/\112-01/'|
    sed 's/\(.*\)[qQ]1-00/\103-30/'|
    sed 's/\(.*\)[qQ]2-00/\106-29/'|
    sed 's/\(.*\)[qQ]3-00/\109-29/'|
    sed 's/\(.*\)[qQ]4-00/\112-29/'|
    awk -F"-" '{if($3==00) printf("%s%s%s%s%s\n","t:",$1,"-",$2,"-28"); else printf("%s%s%s%s%s%s\n","t:",$1,"-",$2,"-",$3)}'`
#    echo ${item}
#    echo $date1
    todo.sh append ${item} $date1
#    echo ${count} 
#    echo ${date1} 
#    count=$((count+1));

done

