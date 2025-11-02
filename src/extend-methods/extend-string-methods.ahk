/**
 * Extension methods for AutoHotkey String objects.
 * Provides utility functions for string manipulation and queries.
 */
class StringExt {
    /**
     * Patches the String prototype with extended methods if enabled in ARConfig.
     */
    static patch() {
        if (!ARConfig.useExtendMethods) {
            return
        }

        for method, enabled in ARConfig.enableExtendMethods.string.OwnProps() {
            if (enabled) {
                String.Prototype.%method% := ObjBindMethod(this, method)
            }
        }
    }

    /**
     * Returns the length of a string.
     * @param {string} str - The string to measure.
     * @returns {number} Length of the string.
     */
    static length(str) => StrLen(str)
    
    /**
     * Converts a string to lowercase.
     * @param {string} str - The string to convert.
     * @returns {string} Lowercase string.
     */
    static toLower(str) => StrLower(str)
    
    /**
     * Converts a string to uppercase.
     * @param {string} str - The string to convert.
     * @returns {string} Uppercase string.
     */
    static toUpper(str) => StrUpper(str)
    
    /**
     * Converts a string to title case.
     * @param {string} str - The string to convert.
     * @returns {string} Title case string.
     */
    static toTitle(str) => StrTitle(str)
    
    /**
     * Trims whitespace from both ends of a string.
     * @param {string} str - The string to trim.
     * @param {string} [chars] - Characters to trim (optional).
     * @returns {string} Trimmed string.
     */
    static trim(str, chars := " ") => Trim(str, chars)
    
    /**
     * Trims whitespace from the start of a string.
     * @param {string} str - The string to trim.
     * @param {string} [chars] - Characters to trim (optional).
     * @returns {string} Trimmed string.
     */
    static trimStart(str, chars := " ") => LTrim(str, chars)
    
    /**
     * Trims whitespace from the end of a string.
     * @param {string} str - The string to trim.
     * @param {string} [chars] - Characters to trim (optional).
     * @returns {string} Trimmed string.
     */
    static trimEnd(str, chars := " ") => RTrim(str, chars)
    
    /**
     * Checks if a string includes a substring.
     * @param {string} haystack - The string to search in.
     * @param {string} needle - The substring to search for.
     * @param {boolean} [caseSense] - Case sensitivity (optional).
     * @param {integer} [startPos] - Starting position (optional).
     * @returns {number} Position of substring or 0 if not found.
     */
    static includes(haystack, needle, caseSense := false, startPos := 1) => InStr(haystack, needle, caseSense, startPos)
    
    /**
     * Replaces occurrences of a substring in a string.
     * @param {string} str - The string to modify.
     * @param {string} needle - The substring to replace.
     * @param {string} replacement - The replacement string.
     * @param {boolean} [caseSense] - Case sensitivity (optional).
     * @param {integer} [outputVarCount] - Output variable for count (optional).
     * @param {integer} [limit] - Limit of replacements (optional).
     * @returns {string} String with replacements.
     */
    static replace(str, needle, replacement := "", caseSense := false, &outputVarCount := 0, limit := -1) => StrReplace(str, needle, replacement, caseSense, &outputVarCount, limit)
    
    /**
     * Splits a string into an array.
     * @param {string} str - The string to split.
     * @param {string} [delimiters] - Delimiters (optional).
     * @param {string} [omitChars] - Characters to omit (optional).
     * @returns {Array} Array of substrings.
     */
    static split(str, delimiters := ",", omitChars := "") => StrSplit(str, delimiters, omitChars)
    
    /**
     * Returns a substring from a string.
     * @param {string} str - The string to extract from.
     * @param {integer} start - Starting position (1-based).
     * @param {integer} [length] - Length of substring (optional).
     * @returns {string} Substring.
     */
    static substr(str, start, length := "") => SubStr(str, start, length)

    /**
     * Replaces multiple substrings in a string.
     * @param {string} str - The original string.
     * @param {Array} needles - Array of substrings to replace.
     * @param {string} [replaceText] - Replacement text.
     * @param {boolean} [caseSense] - Case sensitivity.
     * @param {number} [outputVarCount] - Output variable for count.
     * @param {number} [limit] - Limit of replacements.
     * @returns {string} Modified string.
     */
    static replaceThese(str, needles, replaceText := "", caseSense := false, &outputVarCount := 0, limit := -1) {
        checkType(needles, Array)

        for needle in needles {
            str := StrReplace(str, needle, replaceText, caseSense, &outputVarCount, limit)
        }

        return str
    }

    /**
     * Repeats a string a specified number of times.
     * @param {string} str - The string to repeat.
     * @param {number} times - Number of repetitions.
     * @returns {string} Repeated string.
     */
    static repeat(str, times) {
        newStr := ""
        
        loop times {
            newStr .= str
        }

        return newStr
    }

    /**
     * Returns a slice of a string from start to end.
     * @param {string} str - The string to slice.
     * @param {number} start - Start index (1-based).
     * @param {number} [end] - End index (defaults to string length).
     * @returns {string} Sliced string.
     */
    static slice(str, start, end := StrLen(str)) {
        newStr := ""

        loop parse str {
            if A_Index < start {
                continue
            }

            newStr .= A_LoopField

        } until A_Index == end - 1

        return newStr
    }

    static startsWith(haystack, needle, caseSense := false, startPos := 1) {
        index := InStr(haystack, needle, caseSense, startPos)

        return index == startPos ? true : false
    }

    static endsWith(haystack, needle, caseSense := false) {
        startPos := StrLen(haystack) - StrLen(needle) + 1
        index := InStr(haystack, needle, caseSense, )

        return index == startPos ? true : false
    }
}