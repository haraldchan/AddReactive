/**
 * Utility class for working with durations and date/time calculations.
 * Provides methods for converting, formatting, and comparing durations.
 */
class Duration {
    /**
     * Patches Integer and String prototypes with duration methods if enabled in ARConfig.
     */
    static use() {
        if (!ARConfig.useExtendClasses) {
            return
        }

        for method, enabled in ARConfig.enableExtendClasses.duration.integer.OwnProps() {
            if (enabled) {
                Integer.Prototype.%method% := ObjBindMethod(this, method)
            }
        }

        for method, enabled in ARConfig.enableExtendClasses.duration.string.OwnProps() {
            if (enabled) {
                String.Prototype.%method% := ObjBindMethod(this, method)
            }
        }
    }

    ; integer
    /**
     * Returns a TimeUnit object representing seconds.
     * @param {number} duration - Number of seconds.
     * @returns {TimeUnit}
     */
    static seconds(duration) => TimeUnit(duration, "Seconds")
    
    /**
     * Returns a TimeUnit object representing minutes.
     * @param {number} duration - Number of minutes.
     * @returns {TimeUnit}
     */
    static minutes(duration) => TimeUnit(duration, "Minutes")
    
    /**
     * Returns a TimeUnit object representing hours.
     * @param {number} duration - Number of hours.
     * @returns {TimeUnit}
     */
    static hours(duration) => TimeUnit(duration, "Hours")
    
    /**
     * Returns a TimeUnit object representing days.
     * @param {number} duration - Number of days.
     * @returns {TimeUnit}
     */
    static days(duration) => TimeUnit(duration, "Days")
    
    ; string/date
    /**
     * Returns the number of seconds between two dates.
     * @param {string} fromDate - Start date/time.
     * @param {string} toDate - End date/time.
     * @returns {number}
     */
    static secondsBetween(fromDate, toDate) => DateDiff(toDate, fromDate, "Seconds") 
    
    /**
     * Returns the number of minutes between two dates.
     * @param {string} fromDate - Start date/time.
     * @param {string} toDate - End date/time.
     * @returns {number}
     */
    static minutesBetween(fromDate, toDate) => DateDiff(toDate, fromDate, "Minutes")
    
    /**
     * Returns the number of hours between two dates.
     * @param {string} fromDate - Start date/time.
     * @param {string} toDate - End date/time.
     * @returns {number}
     */
    static hourBetween(fromDate, toDate) => DateDiff(toDate, fromDate, "Hours")
    
    /**
     * Returns the number of days between two dates.
     * @param {string} fromDate - Start date/time.
     * @param {string} toDate - End date/time.
     * @returns {number}
     */
    static daysBetween(fromDate, toDate) => DateDiff(toDate, fromDate, "Days")

    /**
     * Returns the date/time for tomorrow based on a given date.
     * @param {string} fromDate - The reference date.
     * @param {number} [time] - Optional time value.
     * @returns {string}
     */
    static tomorrow(fromDate, time := 0) => this.nextDay(fromDate, time)
    
    /**
     * Returns the date/time for the next day based on a given date.
     * @param {string} fromDate - The reference date.
     * @param {number} [time] - Optional time value.
     * @returns {string}
     */
    static nextDay(fromDate, time := 0) => time ? FormatTime(DateAdd(fromDate, 1, "Days"), "yyyyMMdd") . time : DateAdd(fromDate, 1, "Days")
    
    /**
     * Returns the date/time for the previous day based on a given date.
     * @param {string} fromDate - The reference date.
     * @param {number} [time] - Optional time value.
     * @returns {string}
     */
    static yesterday(fromDate, time := 0) => time ? FormatTime(DateAdd(fromDate, -1, "Days"), "yyyyMMdd") . time : DateAdd(fromDate, -1, "Days")
    
    /**
     * Formats a time value according to the specified format.
     * @param {string} time - The time value.
     * @param {string} timeFormat - The format string.
     * @returns {string}
     */
    static toFormat(time, timeFormat) => checkType(time, IsTime) && FormatTime(time, timeFormat)
}

/**
 * Represents a time unit and provides methods for date/time arithmetic.
 */
class TimeUnit {
    /**
     * Constructs a TimeUnit object.
     * @param {number} value - The amount of time units.
     * @param {string} unitType - The type of unit (Seconds, Minutes, Hours, Days).
     */
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

    /**
     * Returns the date/time for the specified duration ago from now.
     * @returns {string}
     */
    ago() => DateAdd(A_Now, 0 - this.value, this.unitType)

    /**
     * Returns the date/time for the specified duration from now.
     * @returns {string}
     */
    fromNow() => DateAdd(A_Now, this.value, this.unitType)

    /**
     * Returns the date/time after the specified time by this duration.
     * @param {string} time - The reference time.
     * @returns {string}
     */
    after(time) => this.since(time)
    /**
     * Returns the date/time since the specified time by this duration.
     * @param {string} time - The reference time.
     * @returns {string}
     */
    since(time) => DateAdd(time, this.value, this.unitType)

    /**
     * Returns the date/time before the specified time by this duration.
     * @param {string} time - The reference time.
     * @returns {string}
     */
    before(time) => this.until(time)
    
    /**
     * Returns the date/time until the specified time by this duration.
     * @param {string} time - The reference time.
     * @returns {string}
     */
    until(time) => DateAdd(time, 0 - this.value, this.unitType)

    /**
     * Returns the value of this unit in seconds.
     * @returns {number}
     */
    inSeconds() => this.unitInSeconds.%this.unitType%
    
    /**
     * Returns the value of this unit in minutes.
     * @returns {number}
     */
    inMinutes() => this.unitInSeconds.%this.unitType% / 60
    
    /**
     * Returns the value of this unit in hours.
     * @returns {number}
     */
    inHours() => this.unitInSeconds.%this.unitType% / 60 / 60
    
    /**
     * Returns the value of this unit in days.
     * @returns {number}
     */
    inDays() => this.unitInSeconds.%this.unitType% / 60 / 60 / 24
}
