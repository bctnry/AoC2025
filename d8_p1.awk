#!/usr/bin/env -S awk -f

# chmod +x ./d8_p1.awk
# ./d8_p1.awk < d8_data01.txt

# I finally learned asorti properly. no more insertion sort...

BEGIN {
	FS = ","
    delete x
	delete y
	delete z
	rcnt = 0
}

{
	x[rcnt+1] = int($1)
	y[rcnt+1] = int($2)
	z[rcnt+1] = int($3)
	rcnt++
}

function abs(a) { if (a < 0) { return -a } else { return a } }

function dist(a, b,
			  #local
			  asq, bsq, csq) {
	asq = (x[a] - x[b]); asq = asq * asq
	bsq = (y[a] - y[b]); bsq = bsq * bsq
	csq = (z[a] - z[b]); csq = csq * csq
	return (asq + bsq + csq)
}

function int_cmp(i, v1, j, v2) {
	if (int(v1) < int(v2)) { return -1 }
	else if (int(v1) == int(v2)) { return 0 }
	else { return 1 }
}

function uf_root(uf, i,
				  #local
				  subj) {
	subj = i
	if (!uf[subj]) { uf[subj] = subj; return subj }
	if (uf[subj] == subj) { return subj }
	else {
		uf[subj] = uf_root(uf, uf[subj])
		return uf[subj]
	}
}
function uf_union(uf, i, j,
				  #local
				  ir, jr) {
	ir = uf_root(uf, i)
	jr = uf_root(uf, j)
	if (ir != jr) { uf[ir] = jr }
}
function uf_query(uf, i, j) {
	return uf_root(uf, i) == uf_root(uf, j)
}

END {
	# get edges.
	delete edge_data
	delete edge_index
	edge_cnt = 0
	for (i = 1; i <= rcnt; i++) {
		for (j = i+1; j <= rcnt; j++) {
			edge_index[edge_cnt+1] = (i","j)
			edge_data[edge_cnt+1] = dist(i, j)
			edge_cnt++
		}
	}
	delete sorted_edge_index
	asorti(edge_data, sorted_edge_index, "int_cmp")
	delete uf
	for (i = 1; i <= 1000; i++) {
		e = edge_data[sorted_edge_index[i]]
		ei = edge_index[sorted_edge_index[i]]
		split(ei, eia, ",")
		if (uf_root(uf, eia[1]) != uf_root(uf, eia[2])) {
			uf_union(uf, eia[1], eia[2])
		}
	}
	delete cnt1
	delete cnt1_val
	delete cnt1_idx
	cnt1_cnt = 0
	for (k in uf) {
		cnt1[uf_root(uf, k)]++
	}
	for (k in cnt1) {
		cnt1_val[cnt1_cnt+1] = cnt1[k]
		cnt1_idx[cnt1_cnt+1] = k
		cnt1_cnt ++
	}
	delete sorted_cnt1_idx
	asorti(cnt1_val, sorted_cnt1_idx, "int_cmp")
	ll = length(sorted_cnt1_idx)
	print (cnt1_val[sorted_cnt1_idx[ll]] \
					* cnt1_val[sorted_cnt1_idx[ll-1]] \
					* cnt1_val[sorted_cnt1_idx[ll-2]])
}


# 8 8 8 8
# 19 19 19 19 19
# 13 13
# 17 17



