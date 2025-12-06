#!/usr/bin/env -S awk -f

# chmod +x ./d6_p1.awk
# ./d6_p1.awk < d6_data01.txt

BEGIN {
	delete nt
	ntcnt = 0
	nfcnt = 0
}

{
	for (i = 1; i <= NF; i++) {
		nt[(ntcnt+1),i] = $i
	}
	ntcnt++
	nfcnt = NF
}

END {
	delete cres
	for (i = 1; i <= nfcnt; i++) {
		if (nt[ntcnt,i] == "+") {
			cres[i] = 0
		} else {
			cres[i] = 1
		}
		for (j = 1; j < ntcnt; j++) {
			if (nt[ntcnt,i] == "+") {
				cres[i] += int(nt[j,i])
			} else {
				cres[i] *= int(nt[j,i])
			}
		}
	}
	res = 0
	for (i = 1; i <= length(cres); i++) {
		res += cres[i]
	}
	print res
}

