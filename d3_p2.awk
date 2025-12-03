#!/usr/bin/env -S awk -f

# chmod +x ./d3_p1.awk
# ./d3_p1.awk < d3_data01.txt

BEGIN {
	res = 0
}

function calcmaxl(s, res,
				  #local
				  chr, st, e, i, maxlc) {
	delete res
	for (st = 1; st <= length(s); st++) {
		for (e = st; e <= length(s); e++) {
			maxlc = -1
			for (i = st; i <= e; i++) {
				chr = substr(s, i, 1)
				if (maxlc < int(chr)) { maxlc = int(chr) }
			}
			res[st","e] = maxlc
		}
	}
}

function calcn(s, st, e, maxl, carrier,
			   #local
			   n, tempr, chr, i, j, k, kk, maxt) {
	delete carrier
	# n == 1
	for (i = st; i <= e; i++) {
		for (j = i; j <= e; j++) {
			kk = 1","i","j
			carrier[kk] = maxl[i","j]
		}
	}
	# n >= 2
	for (n = 2; n <= 12; n++) {
		for (i = st; i <= e; i++) {
			for (j = i; j <= e; j++) {
				maxt = -1
				for (k = i; k < j; k++) {
					tempr = carrier[(n-1)","(k+1)","j]
					if (tempr == -1) { continue }
					if (maxt < maxl[i","k] * (10 ** (n - 1)) + tempr) {
						maxt = maxl[i","k] * (10 ** (n - 1)) + tempr
					}
				}
				carrier[n","i","j] = maxt
			}
		}
	}
}

/[[:digit:]]+/ {
	delete maxl
	delete carrier
	calcmaxl($1, maxl)
	calcn($1, 1, length($1), maxl, carrier)
	res += carrier[12","1","(length($1))]
	print "line ", NR, " done"
}

END {
	print res
}

