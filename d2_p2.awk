#!/usr/bin/env -S awk -f

# chmod +x ./d2_p1.awk
# ./d2_p2.awk < d2_data01.txt

BEGIN {
	RS = ","
    FS = "-"
	res = 0
}

function chk(s,
			 #local
			 substrlen, targetstr, k,
			 verdict,
			 slen) {
	slen = length(s)
	for (substrlen = 1; substrlen <= slen / 2; substrlen++) {
		targetstr = substr(s, 1, substrlen)
		verdict = 1
		for (k = 1; k <= slen; k += substrlen) {
			if (substr(s, k, substrlen) != targetstr) {
				verdict = 0
				break
			}
		}
		if (verdict == 1) {
			res += int(s)
			break
		}
	}
}

{
	for (i = int($1); i <= int($2); i++) {
		v = (i "")
		chk(v)
	}
}

END {
	print res
}

