#!/usr/bin/env -S awk -f

# chmod +x ./d11_p1.awk
# ./d11_p1.awk < d11_data01.txt

BEGIN {
	delete keys
	delete vals
	rcnt = 0
}

{
	match($0, /^[[:space:]]*([a-z]+):[[:space:]]*(.*?)[[:space:]]*$/, a)
	keys[a[1]] = NR
	split(a[2], aa)
	vals[NR,"length"] = length(aa)
    for (i = 1; i <= length(aa); i++) { vals[NR,i] = aa[i] }
    rcnt = NR
}

function ss(stp, target,
            #local
			res, next_p, i) {
	if (stp == target) { return 1 }
	if (!keys[stp]) { return 0 }
	res = 0
	for (i = 1; i <= vals[keys[stp],"length"]; i++) {
		next_p = vals[keys[stp],i]
		if (next_p == target) { res++ }
		else { res += ss(next_p, target) }
	}
	return res
}

END {
	print ss("you", "out")
}


