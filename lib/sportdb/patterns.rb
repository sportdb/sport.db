# encoding: utf-8

module SportDb

# collection of regex patterns for reuse (SportDb specific)

### todo: add a patterns.md page to  github ??
##  - add regexper pics??

############
# about ruby regexps
#
# try the rubular - Ruby regular expression editor and tester
#  -> http://rubular.com
#   code -> ??  by ??
#
#
# Jeff Avallone's Regexper - Shows State-Automata Diagrams
#  try -> http://regexper.com
#    code -> https://github.com/javallone/regexper
#
#
#  Regular Expressions | The Bastards Book of Ruby by Dan Nguyen
# http://ruby.bastardsbook.com/chapters/regexes/
#
# move to notes  regex|patterns on  geraldb.github.io ??
#

  TEAM_KEY_PATTERN  = '\A[a-z]{3,}\z'
  TEAM_KEY_PATTERN_MESSAGE = "expected three or more lowercase letters a-z /#{TEAM_KEY_PATTERN}/" 

  # must start w/ letter a-z (2 n 3 can be number or underscore _)
  TEAM_CODE_PATTERN = '\A[A-Z][A-Z0-9][A-Z0-9_]?\z'
  TEAM_CODE_PATTERN_MESSAGE = "expected two or three uppercase letters A-Z (and 0-9_; must start with A-Z) /#{TEAM_CODE_PATTERN}/"


  ## move date n time patterns to text utils ???


  # e.g. 2012-09-14 20:30   => YYYY-MM-DD HH:MM
  #  nb: allow 2012-9-3 7:30 e.g. no leading zero required
  # regex_db
  DB_DATE_TIME_REGEX = /\b
                 (?<year>\d{4})
                   -
                 (?<month>\d{1,2})
                   -
                 (?<day>\d{1,2})
                  \s+
                 (?<hours>\d{1,2})
                   :
                 (?<minutes>\d{2})
                  \b/x

  # e.g. 2012-09-14  w/ implied hours (set to 12:00)
  #  nb: allow 2012-9-3 e.g. no leading zero required
  # regex_db2
  DB_DATE_REGEX = /\b
                    (?<year>\d{4})
                       -
                    (?<month>\d{1,2})
                       -
                    (?<day>\d{1,2})
                     \b/x

  # e.g. 14.09.2012 20:30   => DD.MM.YYYY HH:MM
  #  nb: allow 2.3.2012 e.g. no leading zero required
  #  nb: allow hour as 20.30
  # regex_de
  DE_DATE_TIME_REGEX = /\b
                          (?<day>\d{1,2})
                            \.
                          (?<month>\d{1,2})
                            \.
                          (?<year>\d{4})
                            \s+
                          (?<hours>\d{1,2})
                            [:.]
                          (?<minutes>\d{2})
                            \b/x

  # e.g. 14.09. 20:30  => DD.MM. HH:MM
  #  nb: allow 2.3.2012 e.g. no leading zero required
  #  nb: allow hour as 20.30  or 3.30 instead of 03.30
  # regex_de2
  DE2_DATE_TIME_REGEX = /\b
                        (?<day>\d{1,2})
                           \.
                        (?<month>\d{1,2})
                           \.
                           \s+
                        (?<hours>\d{1,2})
                           [:.]
                        (?<minutes>\d{2})
                          \b/x

  # e.g. 14.09.2012  => DD.MM.YYYY w/ implied hours (set to 12:00)
  # regex_de3
  DE_DATE_REGEX = /\b
                    (?<day>\d{1,2})
                      \.
                    (?<month>\d{1,2})
                      \.
                    (?<year>\d{4})
                      \b/x

  # e.g. 14.09.  => DD.MM. w/ implied year and implied hours (set to 12:00)
  #  note: allow end delimiter ] e.g. [Sa 12.01.] or end-of-string ($) too
  #  note: we use a lookahead for last part e.g. (?:\s+|$|[\]]) - do NOT cosume
  # regex_de4
  DE2_DATE_REGEX = /\b
                     (?<day>\d{1,2})
                        \.
                     (?<month>\d{1,2})
                        \.
                     (?=\s+|$|[\]])/x  ## note: allow end-of-string/line too







end # module SportDb

