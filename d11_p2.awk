#!/usr/bin/env -S awk -f

# chmod +x ./d11_p1.awk
# ./d11_p1.awk < d11_data01.txt

BEGIN {
	delete keys
	delete vals
	delete rev_keys
	delete rev_vals
	delete massive_tally
	delete massive_tally_rev
	rcnt = 0
	rkcnt = 0
}

function add_rev_edge(from, to,
					  #local
					  i) {
	if (!rev_vals[from,"length"]) {
		rev_vals[from,"length"] = 1
		rev_keys[from] = rkcnt+1
		rkcnt ++
	} else {
		rev_vals[from,"length"]++
	}
	rev_vals[from,rev_vals[from,"length"]] = to
}

{
	match($0, /^[[:space:]]*([a-z]+):[[:space:]]*(.*?)[[:space:]]*$/, a)
	keys[a[1]] = NR
	split(a[2], aa)
	vals[NR,"length"] = length(aa)
    for (i = 1; i <= length(aa); i++) {
		vals[NR,i] = aa[i]
		add_rev_edge(aa[i], a[1])
	}
    rcnt = NR
}

function ss_need_nothing_else(stp, target,
							  #local
							  res, next_p, i) {
	if (massive_tally[stp,target]) { return massive_tally[stp,target] }
	if (stp == target) {
		massive_tally[stp,target] = 1
		return 1
	}
	if (!keys[stp]) { return 0 }
	res = 0
	for (i = vals[keys[stp],"length"]; i >= 1; i--b) {
		next_p = vals[keys[stp],i]
		if (next_p == target) { res++ }
		else { res += ss_need_nothing_else(next_p, target) }
	}
	massive_tally[stp,target] = res
	return res
}

function ss_need_nothing_else_rev(stp, target,
							  #local
							  res, next_p, i) {
	if (massive_tally_rev[stp,target]) { return massive_tally_rev[stp,target] }
	if (stp == target) {
		massive_tally_rev[stp,target] = 1
		return 1
	}
	if (!rev_keys[stp]) { return 0 }
	res = 0
	for (i = rev_vals[stp,"length"]; i >= 1; i--b) {
		next_p = rev_vals[stp,i]
		if (next_p == target) { res++ }
		else { res += ss_need_nothing_else_rev(next_p, target) }
	}
	massive_tally_rev[stp,target] = res
	return res
}

END {
	svr_dac = ss_need_nothing_else("svr", "dac")
	print "svr_dac", svr_dac
	
    dac_fft = ss_need_nothing_else("dac", "fft")
	print "dac_fft", dac_fft
	
	fft_out = ss_need_nothing_else("fft", "out")
	print "fft_out", fft_out

	# !!!!!!!!
	# svr_fft = ss_need_nothing_else("svr", "fft")
    svr_fft = ss_need_nothing_else_rev("fft", "svr")
	print "svr_fft", svr_fft
	
    fft_dac = ss_need_nothing_else("fft", "dac")
	print "fft_dac", fft_dac
	
	dac_out = ss_need_nothing_else("dac", "out")
	print "dac_out", dac_out


	print (svr_dac * dac_fft * fft_out) + (svr_fft * fft_dac * dac_out)
}


