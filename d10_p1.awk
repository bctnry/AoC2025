#!/usr/bin/env -S awk -f

# chmod +x ./d10_p2.awk
# ./d10_p2.awk < d10_data01.txt

BEGIN {
	delete lamp
	delete button
	delete joltage
	rcnt = 0
}

{
	split($0, a, " ")
	match(a[1], "\\[(.*)\\]", mr)
	lamp[NR] = mr[1]
	button[NR,"length"] = length(a)-2
    for (i = 2; i <= length(a)-1; i++) {
		match(a[i], "\\((.*)\\)", mr)
		button[NR,(i-1)] = mr[1]
	}
	match(a[length(a)], "{(.*)}", mr)
    joltage[NR] = mr[1]
    rcnt = NR
}

function apply_button(l, btn,
					  #local
					  subs, subj, i, btn_array, btn_i) {
	subj = l
	delete btn_array
	split(btn, btn_array, ",")
    for (i = 1; i <= length(btn_array); i++) {
		btn_i = int(btn_array[i])
        subs = substr(subj, btn_i+1, 1)
		if (subs == ".") { subs = "#" }
		else { subs = "." }
		subj = substr(subj, 1, btn_i) subs substr(subj, btn_i+2)
    }
	return subj
}

function init_queue(q) {
	q["size"] = 0
	q["head"] = 0
	q["tail"] = 0
	q["cap"] = 10000000000
}
function queue_push(q, v,
					#local
	                res) {
	res = q["head"]+1
	q[q["head"]+1] = v
	q["head"] = q["head"]+1
	q["size"] = q["size"]+1
	if (q["head"]+1 > q["cap"]) { q["head"] -= q["cap"] }
	return res
}
function queue_pop(q,
				   #local
				   i, res) {
	res = q[q["tail"]+1]
	q[q["tail"]+1] = ""
	q["tail"] = q["tail"]+1
	q["size"] = q["size"]-1
	if (q["tail"]+1 > q["cap"]) { q["tail"] -= q["cap"] }
	return res
}

function in_queue(q, v,
				  #local
				  ii, i) {
	for (i = 0; i < q["size"]; i++) {
		ii = q["tail"] + i
		if (ii > q["cap"]) { ii -= q["cap"] }
		if (q[ii] == v) { return 1 }
	}
	return 0
}

function is_lamp_all_on(s, i) { return s == i }

function ss(i,
			#local
			j, init_s, applied, subj, subj2, q, q2, cnt) {
	init_queue(q)
	init_queue(q2)
	init_s = ""
	for (j = 1; j <= length(lamp[i]); j++) { init_s = init_s "." }
	queue_push(q, init_s)
	queue_push(q2, 0)
	while (q["size"] > 0) {
		if (q["size"] > q["cap"]) {
			print "!!!!!!!!! OUT OF CAPACITY !!!!!!!!!!!"
			break
		}
		subj = queue_pop(q)
		subj2 = queue_pop(q2)
		if (is_lamp_all_on(subj, lamp[i])) { return subj2 }
		for (j = 1; j <= button[i,"length"]; j++) {
			applied = apply_button(subj, button[i,j])
			if (!in_queue(q, applied)) {
				queue_push(q, applied)
				queue_push(q2, subj2+1)
			}
		}
	}
}
	

END {
	res = 0
    for (i = 1; i <= rcnt; i++) {
		# printf("config %d: %s\n", i, lamp[i])
		# for (j = 1; j <= button[i,"length"]; j++) {
		# 	printf("    button %d: %s (%s)\n", j, button[i,j], apply_button(lamp[i], button[i,j]))
		# }
        # printf("    joltage: %s\n", joltage[i])
		res += ss(i)
		printf("%d/%d\n", i, rcnt)
	}
	print res
}


