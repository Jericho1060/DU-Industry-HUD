--[[
    Jericho's time script -- https://github.com/Jericho1060
    Display IRL date and time in game
    https://github.com/Jericho1060/DualUniverse/edit/master/TimeScript/TimeScript.lua
]]--

function DUCurrentDateTime(utc)
    local t = system.getUtcTime()
    if not utc then t = t + system.getUtcOffset() end
    local DSEC=24*60*60
    local YSEC=365*DSEC
    local LSEC=YSEC+DSEC
    local FSEC=4*YSEC+DSEC
    local BASE_DOW=4
    local BASE_YEAR=1970
    local _days={-1, 30, 58, 89, 119, 150, 180, 211, 242, 272, 303, 333, 364}
    local _lpdays={}
    for i=1,2  do _lpdays[i]=_days[i]   end
    for i=3,13 do _lpdays[i]=_days[i]+1 end
    local y,j,m,d,w,h,n,s
    local mdays=_days
    s=t
    y=math.floor(s/FSEC)
    s=s-y*FSEC
    y=y*4+BASE_YEAR
    if s>=YSEC then
        y=y+1
        s=s-YSEC
        if s>=YSEC then
            y=y+1
            s=s-YSEC
            if s>=LSEC then
                y=y+1
                s=s-LSEC
            else
                mdays=_lpdays
            end
        end
    end
    j=math.floor(s/DSEC)
    s=s-j*DSEC
    local m=1
    while mdays[m]<j do m=m+1 end
    m=m-1
    local d=j-mdays[m]
    w=(math.floor(t/DSEC)+BASE_DOW)%7
    if w == 0 then w = 7 end
    h=math.floor(s/3600)
    s=s-h*3600
    n=math.floor(s/60)
    function round(a,b)if b then return utils.round(a/b)*b end;return a>=0 and math.floor(a+0.5)or math.ceil(a-0.5)end
    s=round(s-n*60)
    local weekDaysNames = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"}
    local weekDaysShortNames = {"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"}
    local monthNames = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}
    local monthShortNames = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}
    return y,m,d,h,n,s,w,weekDaysNames[w],weekDaysShortNames[w],monthNames[m],monthShortNames[m],j+1
end

--[[
    local year, month, day, hour, minute, second, weekDayIndex, weekDayName, weekDayShortName, monthName, monthShortName, daysFromYearStart = DUCurrentDateTime()
    system.print(string.format("%02d/%02d/%04d %02d:%02d:%02d",day,month,year,hour,minute,second))
]]
