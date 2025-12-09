#!/usr/bin/env -S awk -f

# chmod +x ./d9_p1.awk
# ./d9_p1.awk < d9_data01.txt

BEGIN {
	FS = ","
    delete x
    delete y
    rcnt = 0
}

{
    x[NR] = $1
    y[NR] = $2
    rcnt = NR
}

function abs(x) { if (x < 0) { return -x } else { return x } }

END {
	maxarea = 0
	for (i = 1; i <= rcnt; i++) {
		for (j = i+1; j <= rcnt; j++) {
			if (maxarea < (abs(x[i] - x[j]) + 1) * (abs(y[i] - y[j]) + 1)) {
				maxarea = (abs(x[i] - x[j]) + 1) * (abs(y[i] - y[j]) + 1)
			}
		}
	}
	print maxarea
}


