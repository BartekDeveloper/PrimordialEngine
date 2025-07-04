package eng_utils

import "core:strings"

IsReallyEmpty :: proc(str: string) -> (isEmpty: bool = true) {
    if len(str) == 0                 do return
    if str              == ""                do return

    firstChar := (rune)(str[0])
    if strings.is_separator(firstChar)   do return
    if strings.is_delimiter(firstChar)   do return
    if strings.is_null(firstChar)        do return
    if strings.is_space(firstChar)       do return
    if strings.is_ascii_space(firstChar) do return

    return false
}
