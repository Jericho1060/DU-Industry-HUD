--[[
	Clock script from Leodr, modified and updated by Jericho
	original script: https://github.com/leodr99/DU-quick_n_dirty-scripts/blob/main/clock/clock.lua
]]
--Globals
local outputTime = false --for debug
local summertime = false --export: summer time enabled
--
--//functions
function epochTime()
    function rZ(data)
        if string.len(data) <= 1 then
            return "0" .. data
        else
            return data
        end
    end
    function dPoint(value)
        if not(value == math.floor(value)) then
            return true
        else
            return false
        end
    end
    function lYear(year)
        if(not dPoint(year / 4)) then
            if(dPoint(year / 100)) then
                return true
            else
                if(not dPoint(year / 400)) then
                    return true
                else
                    return false
                end
            end
        else
            return false
        end
    end

    local timeStampDayOfWeak = 5
    local secondsInHour = 3600
    local secondsInDay = 86400
    local secondsInYear = 31536000
    local secondsInLeapYear = 31622400
    local monthWith28 = 2419200
    local monthWith29 = 2505600
    local monthWith30 = 2592000
    local monthWith31 = 2678400
    local monthsWith30 = {4, 6, 9, 11}
    local monthsWith31 = {1, 3, 5, 7, 8, 10, 12}
    local daysSinceEpoch = 0
    local duEpochOffset = 1506816000 --(Oct. 1, 2017, at 00:00) //1506729600
    local DOWAssociates = {"Tur,", "Fri,", "Sat,", "Sun,", "Mon,", "Tue,", "Wed,"}
    	local getTime = system.getTime()
    	if summertime == true then getTime = getTime + 3600 end

        now = math.floor(getTime + duEpochOffset)
        year = 1970 --the original epoch time (1/1/1970), in order to match DU's epoch offset.
        secs = 0
        daysSinceEpoch = 0
        while((secs + secondsInLeapYear) < now or (secs + secondsInYear) < now) do
            if(lYear(year+1)) then
                if((secs + secondsInLeapYear) < now) then
                    secs = secs + secondsInLeapYear
                    year = year + 1
                    daysSinceEpoch = daysSinceEpoch + 366
                end
            else
                if((secs + secondsInYear) < now) then
                    secs = secs + secondsInYear
                    year = year + 1
                    daysSinceEpoch = daysSinceEpoch + 365
                end
            end
        end
        secondsRemaining = now - secs
        monthSecs = 0
        yearlYear = lYear(year)
        month = 1 -- January
        while((monthSecs + monthWith28) < secondsRemaining or (monthSecs + monthWith30) < secondsRemaining or (monthSecs + monthWith31) < secondsRemaining) do
            if(month == 1) then
                if((monthSecs + monthWith31) < secondsRemaining) then
                    month = 2
                    monthSecs = monthSecs + monthWith31
                    daysSinceEpoch = daysSinceEpoch + 31
                else
                    break
                end
            end
            if(month == 2) then
                if(not yearlYear) then
                    if((monthSecs + monthWith28) < secondsRemaining) then
                        month = 3
                        monthSecs = monthSecs + monthWith28
                        daysSinceEpoch = daysSinceEpoch + 28
                    else
                        break
                    end
                else
                    if((monthSecs + monthWith29) < secondsRemaining) then
                        month = 3
                        monthSecs = monthSecs + monthWith29
                        daysSinceEpoch = daysSinceEpoch + 29
                    else
                        break
                    end
                end
            end
            if(month == 3) then
                if((monthSecs + monthWith31) < secondsRemaining) then
                    month = 4
                    monthSecs = monthSecs + monthWith31
                    daysSinceEpoch = daysSinceEpoch + 31
                else
                    break
                end
            end
            if(month == 4) then
                if((monthSecs + monthWith30) < secondsRemaining) then
                    month = 5
                    monthSecs = monthSecs + monthWith30
                    daysSinceEpoch = daysSinceEpoch + 30
                else
                    break
                end
            end
            if(month == 5) then
                if((monthSecs + monthWith31) < secondsRemaining) then
                    month = 6
                    monthSecs = monthSecs + monthWith31
                    daysSinceEpoch = daysSinceEpoch + 31
                else
                    break
                end
            end
            if(month == 6) then
                if((monthSecs + monthWith30) < secondsRemaining) then
                    month = 7
                    monthSecs = monthSecs + monthWith30
                    daysSinceEpoch = daysSinceEpoch + 30
                else
                    break
                end
            end
            if(month == 7) then
                if((monthSecs + monthWith31) < secondsRemaining) then
                    month = 8
                    monthSecs = monthSecs + monthWith31
                    daysSinceEpoch = daysSinceEpoch + 31
                else
                    break
                end
            end
            if(month == 8) then
                if((monthSecs + monthWith31) < secondsRemaining) then
                    month = 9
                    monthSecs = monthSecs + monthWith31
                    daysSinceEpoch = daysSinceEpoch + 31
                else
                    break
                end
            end
            if(month == 9) then
                if((monthSecs + monthWith30) < secondsRemaining) then
                    month = 10
                    monthSecs = monthSecs + monthWith30
                    daysSinceEpoch = daysSinceEpoch + 30
                else
                    break
                end
            end
            if(month == 10) then
                if((monthSecs + monthWith31) < secondsRemaining) then
                    month = 11
                    monthSecs = monthSecs + monthWith31
                    daysSinceEpoch = daysSinceEpoch + 31
                else
                    break
                end
            end
            if(month == 11) then
                if((monthSecs + monthWith30) < secondsRemaining) then
                    month = 12
                    monthSecs = monthSecs + monthWith30
                    daysSinceEpoch = daysSinceEpoch + 30
                else
                    break
                end
            end
        end
        day = 1 -- 1st
        daySecs = 0
        daySecsRemaining = secondsRemaining - monthSecs
        while((daySecs + secondsInDay) < daySecsRemaining) do
            day = day + 1
            daySecs = daySecs + secondsInDay
            daysSinceEpoch = daysSinceEpoch + 1
        end
        hour = 0 -- Midnight
        hourSecs = 0
        hourSecsRemaining = daySecsRemaining - daySecs
        while((hourSecs + secondsInHour) < hourSecsRemaining) do
            hour = hour + 1
            hourSecs = hourSecs + secondsInHour
        end
        minute = 0 -- Midnight
        minuteSecs = 0
        minuteSecsRemaining = hourSecsRemaining - hourSecs
        while((minuteSecs + 60) < minuteSecsRemaining) do
            minute = minute + 1
            minuteSecs = minuteSecs + 60
        end
        second = math.floor(now % 60)
        year = rZ(year)
        month = rZ(month)
        day = rZ(day)
        hour = rZ(hour)
        minute = rZ(minute)
        second = rZ(second)
        remanderForDOW = daysSinceEpoch % 7
        DOW = DOWAssociates[remanderForDOW]

        if(outputTime) then
            str = "Year: " .. year .. ", Month: " .. month .. ", Day: " .. day .. ", Hour: " .. hour .. ", Minute: " .. minute .. ", Second: ".. second .. ", Day of Week: " .. DOW
            system.print(str)
        end
    return year, month, day, hour, minute, second, DOW
end