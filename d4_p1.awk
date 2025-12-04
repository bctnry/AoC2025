#!/usr/bin/env -S awk -f

# chmod +x ./d4_p1.awk
# ./d4_p1.awk < d4_data01.txt

BEGIN {
	delete map
	width = 0
	height = 0
	vx[1] = -1
	vx[2] = 0
	vx[3] = 1
	vx[4] = -1
	vx[5] = 1
	vx[6] = -1
	vx[7] = 0
	vx[8] = 1
	vy[1] = -1
	vy[2] = -1
	vy[3] = -1
	vy[4] = 0
	vy[5] = 0
	vy[6] = 1
	vy[7] = 1
	vy[8] = 1
}

{
	width = length($0)
	height = NR
	for (i = 1; i <= length($0); i++) {
		k = NR","i
		map[k] = substr($0, i, 1)
	}
}

function in_range(x, st, e) {
	return (x >= st && x <= e)
}

function get_c(x, y,
			   #local
			   cnt, k, i) {
	cnt = 0
	if (map[y","x] == ".") { return 0 }
	for (i = 1; i <= 8; i++) {
		if (in_range(x+vx[i], 1, width) && in_range(y+vy[i], 1, height)) {
			k = (y+vy[i])","(x+vx[i])
            if (map[k] == "@") {
				cnt += 1
			}
		}
	}
	return cnt <= 3
}

END {
	res = 0
	for (j = 1; j <= height; j++) {
		for (i = 1; i <= width; i++) {
			res += get_c(i, j)
		}
	}
	print res
}

