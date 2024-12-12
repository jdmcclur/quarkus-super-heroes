count=0;
total=0; 

min=0
max=0
for i in $(cat ${1} | grep First | awk '{print $6}')
do
 #echo ${i}
 if [[ $min == 0 || $i < $min ]]
 then
   min=$i
 fi
 if [[ $max == 0 || $i > $max ]]
 then
   max=$i
 fi
 total=$(echo $total+$i | bc )
((count++))
done
echo "First Request (ms)"
echo "scale=2; $total / $count" | bc

standardDeviation=$(
    (cat ${1} | grep First | awk '{print $6}') |
        awk '{sum+=$1; sumsq+=$1*$1}END{print sqrt(sumsq/NR - (sum/NR)**2)}'
)

echo "min=$min, max=$max, stdev=$standardDeviation"

count=0;
total=0;
min=0
max=0

for i in $(cat ${1} | grep Foot | awk '{print $5}')
do
 #echo ${i}
 if [[ $min == 0 || $i < $min ]]
 then
   min=$i
 fi
 if [[ $max == 0 || $i > $max ]]
 then
   max=$i
 fi
 total=$(echo $total+$i | bc )
((count++))
done
echo "Footprint (MB)"
echo "scale=2; $total / $count" | bc
standardDeviation=$(
    (cat ${1} | grep Foot | awk '{print $5}') |
        awk '{sum+=$1; sumsq+=$1*$1}END{print sqrt(sumsq/NR - (sum/NR)**2)}'
)

echo "min=$min, max=$max, stdev=$standardDeviation"
