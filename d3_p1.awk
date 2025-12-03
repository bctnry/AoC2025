#!/usr/bin/env -S awk -f

# chmod +x ./d3_p1.awk
# ./d3_p1.awk < d3_data01.txt

BEGIN {
	res = 0
}

function calc(s,
			  #local
			  chr,
			  maxlc, maxrc, maxt,
			  i, maxl, maxr) {
	delete maxl
	delete maxr
	maxlc = 0
	maxrc = 0
	for (i = 1; i <= length(s); i++) {
		chr = substr(s, i, 1)
		if (maxlc < int(chr)) {
			maxlc = int(chr)
		}
		chr = substr(s, length(s)-i+1, 1)
		if (maxrc < int(chr)) {
			maxrc = int(chr)
		}
		maxl[i] = maxlc
		maxr[length(s)-i+1] = maxrc
	}
	maxt = 0
	for (i = 1; i < length(s); i++) {
		if (maxt < maxl[i] * 10 + maxr[i+1]) {
			maxt = maxl[i] * 10 + maxr[i+1]
		}
	}
	return maxt
}

{ res += calc($1) }

END {
	print res
}

