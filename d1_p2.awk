#!/usr/bin/env -S awk -f

# chmod +x ./d1_p2.awk
# ./d1_p2.awk < d1_data01.txt

BEGIN {
	dial_position = 50
	cnt = 0
}

/R([[:digit:]]+)/ {
	match($1, /R([[:digit:]]+)/, a)
	dial_position += int(a[1])
	while (dial_position > 99) {
		dial_position -= 100
		cnt += 1
	}
}

/L([[:digit:]]+)/ {
	match($1, /L([[:digit:]]+)/, a)
	if (dial_position == 0) { dial_position = 100 }
	dial_position -= int(a[1])
	while (dial_position < 0) {
		dial_position += 100
		cnt += 1
	}
	if (dial_position == 0) { cnt += 1 }
}


END {
	print cnt
}


