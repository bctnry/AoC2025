#!/usr/bin/env -S awk -f

# chmod +x ./d7_p1.awk
# ./d7_p1.awk < d7_data01.txt

BEGIN {
	delete m
	mcnt = 0
	width = 0
	delete sidx
	delete sidx2
	sidxcnt = 0
	sidx2cnt = 0
	scnt = 0
}

{
	m[mcnt+1] = $0
	if (width < length($0)) { width = length($0) }
	mcnt++
}

function add_cnt_sidx2(i) {
}

END {
	st_idx = index(m[1], "S")
	sidx[st_idx] = 1
	for (i = 2; i <= mcnt; i++) {
		delete sidx2
		for (j = 1; j <= width; j++) {
			if (substr(m[i], j, 1) == ".") {
				sidx2[j] = sidx[j]
			}
		}
		for (j = 1; j <= width; j++) {
			if (substr(m[i], j+1, 1) == "^") {
				sidx2[j] += sidx[j+1]
			}
			if (substr(m[i], j-1, 1) == "^") {
				sidx2[j] += sidx[j-1]
			}
		}
		delete sidx
		for (j = 1; j <= width; j++) {
			sidx[j] = sidx2[j]
		}
	}
	res = 0
	for (j = 1; j <= width; j++) {
		res += sidx[j]
	}
	print res
}

