class Duration {
    class TimeUnit {
        __New(span, unitType) {
            this.span := span
            this.unitType := unitType
        }

        ago() => DateAdd(A_Now, 0 - this.span, this.unitType)

        fromNow() => DateAdd(A_Now, this.span, this.unitType)

        after(time) => this.since(time)
        since(time) {
            if (!IsTime(time)) {
                Throw TypeError("Value does not fulfill YYYYMMDDHH24MISS format", -1, time)
            }

            return DateAdd(time, this.span, this.unitType)
        }

        before(time) => this.until(time)
        until(time) {
            if (!IsTime(time)) {
                Throw TypeError("Value does not fulfill YYYYMMDDHH24MISS format", -1, time)
            }

            return DateAdd(time, 0 - this.span, this.unitType)
        }
    }

    static seconds(duration) => this.TimeUnit(duration, "Seconds")
    static minutes(duration) => this.TimeUnit(duration, "Minutes")
    static hours(duration) => this.TimeUnit(duration, "Hours")
    static days(duration) => this.TimeUnit(duration, "Days")
}

Integer.Prototype.days := (i) => Duration.days(i)


String.Prototype.daysToDate := daysToDate
daysToDate(fromDate, toDate) {
    if (!IsTime(fromDate)) {
        Throw TypeError("Value does not fulfill YYYYMMDDHH24MISS format", -1, fromDate)
    }

    if (!IsTime(toDate)) {
        Throw TypeError("Value does not fulfill YYYYMMDDHH24MISS format", -1, toDate)
    }

    return DateDiff(toDate, fromDate, "Days")
}

MsgBox(
    5.days().ago()
)

MsgBox(
    5.days().since("20240505")
)

MsgBox(
    "20250101".daysToDate("20250105")
)
