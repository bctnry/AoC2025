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

END {
	st_idx = index(m[1], "S")
	sidx[sidxcnt+1] = st_idx
	sidxcnt++
	for (i = 2; i <= mcnt; i++) {
		delete sidx2
		sidx2cnt = 0
		for (j = 1; j <= sidxcnt; j++) {
			if (substr(m[i], sidx[j], 1) == ".") {
				if (sidx2[sidx2cnt] != sidx[j]) {
					sidx2[sidx2cnt+1] = sidx[j]
					sidx2cnt++
				}
			} else if (substr(m[i], sidx[j], 1) == "^") {
				scnt++
				sidx2[sidx2cnt+1] = sidx[j]-1
				sidx2cnt++
				sidx2[sidx2cnt+1] = sidx[j]+1
				sidx2cnt++
			}
		}
		delete sidx
		sidxcnt = 0
		for (j = 1; j <= sidx2cnt; j++) {
			sidx[sidxcnt+1] = sidx2[j]
			sidxcnt++
		}
	}
	print scnt
}

