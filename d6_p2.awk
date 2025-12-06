#!/usr/bin/env -S awk -f

# chmod +x ./d6_p1.awk
# ./d6_p1.awk < d6_data01.txt

BEGIN {
	delete nt
	ntcnt = 0
	nfcnt = 0
}

{
	nt[NR] = $0
	ntcnt++
	if (length($0) > nfcnt) {
		nfcnt = length($0)
	}
}

function delim(i,
			   #local
			   ii, res) {
	if (i > nfcnt) { return 1 }
	for (ii = 1; ii <= ntcnt; ii++) {
		if (substr(nt[ii], i, 1) != " ") {
			return 0
		}
	}
	return 1
}

function next_delim(i,
					#local
					ii) {
	for (ii = i; ii <= nfcnt; ii++) {
		if (delim(ii)) { return ii }
	}
	return nfcnt+1
}

function read_col(i,
				  #local
				  res, ii) {
	res = 0
	for (ii = 1; ii < ntcnt; ii++) {
		if (substr(nt[ii], i, 1) != " ") {
			res *= 10
			res += int(substr(nt[ii], i, 1))
		}
	}
	return res
}

function read_group(i,
					#local
					mult, plus, c, ci, res, ii) {
	delete c
	ci = 0
	for (ii = i; ii <= nfcnt; ii++) {
		if (delim(ii)) { break }
		c[ci+1] = read_col(ii)
		ci++
	}
	mult = 0
	plus = 0
	for (ii = i; ii <= nfcnt; ii++) {
		if (substr(nt[ntcnt], ii, 1) == " ") { continue }
		else if (substr(nt[ntcnt], ii, 1) == "*") {
			mult = 1
			break
		}
		else if (substr(nt[ntcnt], ii, 1) == "+") {
			plus = 1
			break
		}
	}
	if (mult) {
		res = 1
		for (ii = 1; ii <= ci; ii++) {
			res *= c[ii]
		}
		return res
	} else if (plus) {
		res = 0
		for (ii = 1; ii <= ci; ii++) {
			res += c[ii]
		}
		return res
	}
}

END {
	delete cres
	ci = 0
	iii = 1
	while (iii <= nfcnt) {
		cres[ci+1] = read_group(iii)
		iii = next_delim(iii)+1
		ci++
	}
	res = 0
	for (i = 1; i <= ci; i++) {
		res += cres[i]
	}
	print res
}

