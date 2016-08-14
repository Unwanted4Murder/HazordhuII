proc
	#if DM_VERSION < 510
	replacetext(t,t2,t3)
		return copytext(t,1,findtext(t,t2))+t3+copytext(t,findtext(t,t2)+length(t2),0)
	replaceall(t,t2,t3)
		while(findtext(t,t2))t=replacetext(t,t2,t3)
		return t
	#endif
	deletetext(t,t2)	return copytext(t,1,findtext(t,t2))+copytext(t,findtext(t,t2)+length(t2),0)
	deleteall(t,t2)
		while(findtext(t,t2))t=deletetext(t,t2)
		return t
	inserttext(t,t2,n)	return copytext(t,1,n>0?n+1 : length(t)+1)+t2+copytext(t,n>0?n+1 : length(t)+1,0)
	words2list(t,sep=" ")
		for(var/T in list(".",",","!",":","?"))t=deleteall(t,T)
		var/list/words=list()
		var/word=""
		var/start=1
		var/end=0
		var/length=length(t)
		for(var/n=1,n<length,n++)
			end=findtext(t,sep,start)
			word=copytext(t,start,end)
			words+=word
			start=end+1
			if(!end)break
		return words

	list2words(words[], separator = " ")
		if(!istype(words)) return
		. = ""
		for(var/n in 1 to words.len)
			. += words[n]
			if(n != words.len)
				. += separator

	scrambleword(t)
		var/list/chars[length(t)]
		var/n=1
		while(n<=length(t))
			var/N=rand(1,length(t))
			if(!chars[N])chars[N]=copytext(t,n,++n)
		for(var/T in chars).+=T

	scrambletext(t)
		var/list/words=words2list(t)
		for(var/T in words).+="[scrambleword(T)] "

	wordcount(t)
		var/list/words=words2list(t)
		return words.len

	isletter(t) return (text2ascii(lowertext(t)) in 97 to 122)
	capitalize(t) return uppertext(copytext(t, 1, 2)) + copytext(t, 2)

	printlist(l[])
		. = "list("
		for(var/n in 1 to l.len)
			. += "[l[n]]"
			if(n == l.len)
				. += ")"
			else . += ", "

	clean_list(l[]) if(istype(l)) while(l.Remove(null))

	//misc procs
	hasShiftKey(params, right)
		var p[] = params2list(params)
		return p["shift"] && !p["alt"] && !p["ctrl"] && (!right || p["right"])

	hasCtrlKey(params, right)
		var p[] = params2list(params)
		return !p["shift"] && !p["alt"] && p["ctrl"] && (!right || p["right"])

	hasAltKey(params, right)
		var p[] = params2list(params)
		return !p["shift"] && p["alt"] && !p["ctrl"] && (!right || p["right"])

	hasRightClick(params, exclusive)
		var p[] = params2list(params)
		return p["right"] && (!exclusive || !p["shift"] && !p["alt"] && !p["ctrl"])

atom
	proc
		shiftKey(mob/m, right)
		ctrlKey(mob/m, right)
		altKey(mob/m, right)
		rightClick(mob/m)

	Click(location,control,params)
		var right = hasRightClick(params)
		if(right)
			if(hasShiftKey(params, TRUE)) shiftKey(usr, TRUE)
			else if(hasCtrlKey(params, TRUE)) ctrlKey(usr, TRUE)
			else if(hasAltKey(params, TRUE)) altKey(usr, TRUE)
			else rightClick(usr)

		else
			if(hasShiftKey(params)) shiftKey(usr)
			else if(hasCtrlKey(params)) ctrlKey(usr)
			else if(hasAltKey(params)) altKey(usr)
		..()