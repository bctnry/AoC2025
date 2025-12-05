#!/usr/bin/env -S awk -f

# chmod +x ./d5_p1.awk
# ./d5_p1.awk < d5_data01.txt

BEGIN {
	delete rngst
	delete rnge
	rngcnt = 0
	freshcnt = 0
}

/^[[:digit:]]+\-[[:digit:]]+$/ {
	match($0, /([[:digit:]]+)\-([[:digit:]]+)/, matchres)
	rngst[rngcnt+1] = int(matchres[1])
	rnge[rngcnt+1] = int(matchres[2])
	rngcnt++
}
/^[[:digit:]]+$/ {
	for (i = 1; i <= rngcnt; i++) {
		if (rngst[i] <= int($0) && int($0) <= rnge[i]) {
			freshcnt += 1
			break
		}
	}
}

END {
	print freshcnt
}

