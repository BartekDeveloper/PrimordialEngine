# `empty.odin` (in `engine/utils`)

This file provides utility procedures for checking if a string is empty or contains only whitespace/control characters.

## `IsReallyEmpty` procedure

This procedure checks if a given string is "really" empty. It returns `true` if the string is:

-   Of zero length.
-   An empty string literal (`""`).
-   Starts with a separator, delimiter, null character, or any whitespace character (including ASCII whitespace).

Otherwise, it returns `false`.
