#!/usr/bin/env -S awk -f

# chmod +x ./d5_p1.awk
# ./d5_p2.awk < d5_data01.txt

BEGIN {
	delete rngst
	delete rnge
	delete rngsti
	delete rngei
	delete rngsti2
	delete rngei2
	rngcnt = 0
	rngicnt = 0
	rngi2cnt = 0
	freshcnt = 0
}

# we don't have a usable sort function in awk so we have to make our
# own. we have asort and asorti but none of them are what we want for
# this.
function insert_sort(st, e,
					 #local
					 j, jj) {
	for (j = 1; j <= rngicnt; j++) {
		if (rngsti[j] == st) {
			if (rngei[j] < e) {
				break;
			}
		} else if (rngsti[j] > st) {
			break;
		}
	}
    # j: first element that's bigger than or equal to (st, e)
	# we need to insert at j.
	# move all the rest
	for (jj = rngicnt+1; jj >= j+1; jj--) {
		rngsti[jj] = rngsti[jj-1]
		rngei[jj] = rngei[jj-1]
	}
	rngsti[j] = st
	rngei[j] = e
	rngicnt += 1
}

/^[[:digit:]]+\-[[:digit:]]+$/ {
	match($0, /([[:digit:]]+)\-([[:digit:]]+)/, matchres)
	rngst[rngcnt+1] = int(matchres[1])
	rnge[rngcnt+1] = int(matchres[2])
	rngcnt++
	insert_sort(int(matchres[1]), int(matchres[2]))
}

END {
	current_st = rngsti[1]
	current_e = rngei[1]
	i = 1
	for (j = i+1; j <= rngicnt; j++) {
		if (rngsti[j] > current_e) {
			rngsti2[i] = current_st
			rngei2[i] = current_e
			i += 1
			current_st = rngsti[j]
			current_e = rngei[j]
		} else if (rngsti[j] <= current_e) {
			if (rngei[j] > current_e) {
				current_e = rngei[j]
			}
		}
	}
	rngsti2[i] = current_st
	rngei2[i] = current_e
	rngi2cnt = i
	freshcnt = 0
	for (i = 1; i <= rngi2cnt; i++) {
		freshcnt += (rngei2[i] - rngsti2[i] + 1)
	}
	print freshcnt
}

