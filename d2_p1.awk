#!/usr/bin/env -S awk -f

# chmod +x ./d2_p1.awk
# ./d2_p2.awk < d2_data01.txt

BEGIN {
	RS = ","
    FS = "-"
	res = 0
}

{
	for (i = int($1); i <= int($2); i++) {
		v = (i "")
		vl = length(v) / 2
		if (substr(v, 1, vl) == substr(v, 1+vl)) {
			res += v
		}
	}
}

END {
	print res
}

