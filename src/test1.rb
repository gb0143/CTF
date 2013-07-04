$array = [1..10]
$i = 0
while $i < 10 do
	$array[$i] = $i * 3.34
	$i = $i + 1
end
for i in 1..10
	if(i%2 == 0)
		puts $array[i]
	end
end