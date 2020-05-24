# encoding: utf-8

module SportDb

# collection of regex patterns for reuse (SportDb specific)

### todo: add a patterns.md page to  github ??
##  - add regexper pics??

  TEAM_KEY_RE = %r{ \A
                      [a-z_][a-z0-9_]*
                     \z}x
  TEAM_KEY_MESSAGE = "expected one or more lowercase letters a-z (or 0-9 or _; must start with a-z or _)"


  # must start w/ letter A-Z (2nd,3rd,4th or 5th can be number)
  TEAM_CODE_RE = %r{ \A
                       [A-Z_][A-Z0-9_]*
                      \z}x
  TEAM_CODE_MESSAGE = "expected one or more uppercase letters A-Z (or 0-9 or _; must start with A-Z or _)"


end # module SportDb
