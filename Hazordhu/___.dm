#include "__libs\vectors\vec2.dm"
#include "_supercode\_define.dm"
#include "_supercode\_define_settings.dm"

#if THIN_SKIN
	#include "_supercode/interface/thin.dm"
//	#include "_supercode/interface/flash skin.dmf"
	#include "_supercode/interface/flash skin.dms"
#else
	#include "_supercode/interface/interface 6013.dm"
	#include "_supercode/interface/skin.dmf"
#endif