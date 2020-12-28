--[[
	Clock script from Leodr, modified and updated by Jericho
	original script: https://github.com/leodr99/DU-quick_n_dirty-scripts/blob/main/clock/clock.lua
]]
--Globals
local outputTime = false --for debug
local summertime = false --export: summer time enabled
--
--//functions
function epochTime()function rZ(a)if string.len(a)<=1 then return\"0\"..a else return a end end;function dPoint(b)if not(b==math.floor(b))then return true else return false end end;function lYear(year)if not dPoint(year/4)then if dPoint(year/100)then return true else if not dPoint(year/400)then return true else return false end end else return false end end;local c=5;local d=3600;local e=86400;local f=31536000;local g=31622400;local h=2419200;local i=2505600;local j=2592000;local k=2678400;local l={4,6,9,11}local m={1,3,5,7,8,10,12}local n=0;local o=1506816000;local p={\"Tur,\",\"Fri,\",\"Sat,\",\"Sun,\",\"Mon,\",\"Tue,\",\"Wed,\"}local q=system.getTime()if summertime==true then q=q+3600 end;now=math.floor(q+o)year=1970;secs=0;n=0;while secs+g<now or secs+f<now do if lYear(year+1)then if secs+g<now then secs=secs+g;year=year+1;n=n+366 end else if secs+f<now then secs=secs+f;year=year+1;n=n+365 end end end;secondsRemaining=now-secs;monthSecs=0;yearlYear=lYear(year)month=1;while monthSecs+h<secondsRemaining or monthSecs+j<secondsRemaining or monthSecs+k<secondsRemaining do if month==1 then if monthSecs+k<secondsRemaining then month=2;monthSecs=monthSecs+k;n=n+31 else break end end;if month==2 then if not yearlYear then if monthSecs+h<secondsRemaining then month=3;monthSecs=monthSecs+h;n=n+28 else break end else if monthSecs+i<secondsRemaining then month=3;monthSecs=monthSecs+i;n=n+29 else break end end end;if month==3 then if monthSecs+k<secondsRemaining then month=4;monthSecs=monthSecs+k;n=n+31 else break end end;if month==4 then if monthSecs+j<secondsRemaining then month=5;monthSecs=monthSecs+j;n=n+30 else break end end;if month==5 then if monthSecs+k<secondsRemaining then month=6;monthSecs=monthSecs+k;n=n+31 else break end end;if month==6 then if monthSecs+j<secondsRemaining then month=7;monthSecs=monthSecs+j;n=n+30 else break end end;if month==7 then if monthSecs+k<secondsRemaining then month=8;monthSecs=monthSecs+k;n=n+31 else break end end;if month==8 then if monthSecs+k<secondsRemaining then month=9;monthSecs=monthSecs+k;n=n+31 else break end end;if month==9 then if monthSecs+j<secondsRemaining then month=10;monthSecs=monthSecs+j;n=n+30 else break end end;if month==10 then if monthSecs+k<secondsRemaining then month=11;monthSecs=monthSecs+k;n=n+31 else break end end;if month==11 then if monthSecs+j<secondsRemaining then month=12;monthSecs=monthSecs+j;n=n+30 else break end end end;day=1;daySecs=0;daySecsRemaining=secondsRemaining-monthSecs;while daySecs+e<daySecsRemaining do day=day+1;daySecs=daySecs+e;n=n+1 end;hour=0;hourSecs=0;hourSecsRemaining=daySecsRemaining-daySecs;while hourSecs+d<hourSecsRemaining do hour=hour+1;hourSecs=hourSecs+d end;minute=0;minuteSecs=0;minuteSecsRemaining=hourSecsRemaining-hourSecs;while minuteSecs+60<minuteSecsRemaining do minute=minute+1;minuteSecs=minuteSecs+60 end;second=math.floor(now%60)year=rZ(year)month=rZ(month)day=rZ(day)hour=rZ(hour)minute=rZ(minute)second=rZ(second)remanderForDOW=n%7;DOW=p[remanderForDOW]if outputTime then str=\"Year: \"..year..\", Month: \"..month..\", Day: \"..day..\", Hour: \"..hour..\", Minute: \"..minute..\", Second: \"..second..\", Day of Week: \"..DOW;system.print(str)end;return year,month,day,hour,minute,second,DOW end