class Duration {
    static use() {
        if (!ARConfig.useExtendClasses) {
            return
        }

        for method, enabled in ARConfig.extendClasses.duration.integer.OwnProps() {
            if (enabled) {
                Integer.Prototype.%method% := ObjBindMethod(this, method)
            }
        }

        for method, enabled in ARConfig.extendClasses.duration.string.OwnProps() {
            if (enabled) {
                String.Prototype.%method% := ObjBindMethod(this, method)
            }
        }
    }

    static seconds(duration) => TimeUnit(duration, "Seconds")

    static minutes(duration) => TimeUnit(duration, "Minutes")

    static hours(duration) => TimeUnit(duration, "Hours")

    static days(duration) => TimeUnit(duration, "Days")

    static daysToDate(fromDate, toDate) {
        if (!IsTime(fromDate)) {
            Throw TypeError("Value does not fulfill YYYYMMDDHH24MISS format", -1, fromDate)
        }

        if (!IsTime(toDate)) {
            Throw TypeError("Value does not fulfill YYYYMMDDHH24MISS format", -1, toDate)
        }

        return DateDiff(toDate, fromDate, "Days")
    }

    static tomorrow(fromDate) => this.nextDay(fromDate)
    static nextDay(fromDate) {
        if (!IsTime(fromDate)) {
            Throw TypeError("Value does not fulfill YYYYMMDDHH24MISS format", -1, fromDate)
        }

        return DateAdd(fromDate, 1, "Days")
    }
}

class TimeUnit {
    __New(value, unitType) {
        this.value := value
        this.unitType := unitType
        this.unitInSeconds := {
            Seconds: 1,
            Minutes: 60,
            Hours: 3600,
            Days: 86400
        }
    }

    ago() => DateAdd(A_Now, 0 - this.value, this.unitType)

    fromNow() => DateAdd(A_Now, this.value, this.unitType)

    after(time) => this.since(time)
    since(time) {
        if (!IsTime(time)) {
            Throw TypeError("Value does not fulfill YYYYMMDDHH24MISS format", -1, time)
        }

        return DateAdd(time, this.value, this.unitType)
    }

    before(time) => this.until(time)
    until(time) {
        if (!IsTime(time)) {
            Throw TypeError("Value does not fulfill YYYYMMDDHH24MISS format", -1, time)
        }

        return DateAdd(time, 0 - this.value, this.unitType)
    }

    inSeconds() => this.unitInSeconds.%this.unitType%

    inMinutes() => this.unitInSeconds.%this.unitType% / 60

    inHours() => this.unitInSeconds.%this.unitType% / 60 / 60

    inDays() => this.unitInSeconds.%this.unitType% / 60 / 60 / 24
}

