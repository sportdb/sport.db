# encoding: utf-8


module DateFormats

# e.g. 2012-09-14 20:30   => YYYY-MM-DD HH:MM
#  note: allow 2012-9-3 7:30 e.g. no leading zero required
# regex_db
DB__DATE_TIME_RE = /\b
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
#  note: allow 2012-9-3 e.g. no leading zero required
# regex_db2
DB__DATE_RE = /\b
                  (?<year>\d{4})
                     -
                  (?<month>\d{1,2})
                     -
                  (?<day>\d{1,2})
                   \b/x


# e.g. 14.09.2012 20:30   => DD.MM.YYYY HH:MM
#  note: allow 2.3.2012 e.g. no leading zero required
#  note: allow hour as 20.30
# regex_de
DD_MM_YYYY__DATE_TIME_RE = /\b
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
#  note: allow 2.3.2012 e.g. no leading zero required
#  note: allow hour as 20.30  or 3.30 instead of 03.30
# regex_de2
DD_MM__DATE_TIME_RE = /\b
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
DD_MM_YYYY__DATE_RE = /\b
                  (?<day>\d{1,2})
                    \.
                  (?<month>\d{1,2})
                    \.
                  (?<year>\d{4})
                    \b/x

# e.g. 14.09.  => DD.MM. w/ implied year and implied hours (set to 12:00)
#  note: allow end delimiter ] e.g. [Sa 12.01.] or end-of-string ($) too
#  note: we use a lookahead for last part e.g. (?:\s+|$|[\]]) - do NOT cosume
# regex_de4 (use lookahead assert)
DD_MM__DATE_RE = /\b
                   (?<day>\d{1,2})
                      \.
                   (?<month>\d{1,2})
                      \.
                   (?=\s+|$|[\]])/x  ## note: allow end-of-string/line too



##
# e.g. 12 May 2013 14:00  => D|DD.MMM.YYYY H|HH:MM
EN__DD_MONTH_YYYY__DATE_TIME_RE = /\b
              (?<day>\d{1,2})
                 \s
              (?<month_en>#{MONTH_EN})
                 \s
              (?<year>\d{4})
                 \s+
              (?<hours>\d{1,2})
                :
              (?<minutes>\d{2})
                \b/x

###
# fix: pass in lang (e.g. en or es)
#  only process format for lang plus fallback to en?
#   e.g.  EN__DD_MONTH and ES__DD_MONTH depend on order for match (first listed will match)

# e.g. 12 May  => D|DD.MMM  w/ implied year and implied hours
EN__DD_MONTH__DATE_RE = /\b
              (?<day>\d{1,2})
                 \s
              (?<month_en>#{MONTH_EN})
                 \b/x


# e.g.  Jun/12 2011 14:00
EN__MONTH_DD_YYYY__DATE_TIME_RE = /\b
                 (?<month_en>#{MONTH_EN})
                   \/
                 (?<day>\d{1,2})
                   \s
                 (?<year>\d{4})
                   \s+
                 (?<hours>\d{1,2})
                   :
                 (?<minutes>\d{2})
                   \b/x

# e.g.  Jun/12 14:00  w/ implied year H|HH:MM
EN__MONTH_DD__DATE_TIME_RE = /\b
                 (?<month_en>#{MONTH_EN})
                   \/
                 (?<day>\d{1,2})
                   \s+
                 (?<hours>\d{1,2})
                   :
                 (?<minutes>\d{2})
                   \b/x

# e.g. Jun/12 2013  w/ implied hours (set to 12:00)
EN__MONTH_DD_YYYY__DATE_RE = /\b
              (?<month_en>#{MONTH_EN})
                 \/
              (?<day>\d{1,2})
                 \s
              (?<year>\d{4})
                \b/x

# e.g.  Jun/12  w/ implied year and implied hours (set to 12:00)
#  note: allow space too e.g Jun 12   -- check if conflicts w/ other formats??? (added for rsssf reader)
#   -- fix: might eat french weekday mar 12  is mardi (mar)  !!! see FR__ pattern
#  fix: remove  space again for now - and use simple en date reader or something!!!
##  was [\/ ]   changed back to \/
EN__MONTH_DD__DATE_RE = /\b
                 (?<month_en>#{MONTH_EN})
                    \/
                 (?<day>\d{1,2})
                   \b/x


# e.g.  12 Ene  w/ implied year and implied hours (set to 12:00)
ES__DD_MONTH__DATE_RE = /\b
                 (?<day>\d{1,2})
                   \s
                 (?<month_es>#{MONTH_ES})
                   \b/x

# e.g. Ven 8 Août  or [Ven 8 Août] or Ven 8. Août  or [Ven 8. Août]
### note: do NOT consume [] in regex (use lookahead assert)
FR__DAY_DD_MONTH__DATE_RE = /\b
     (?<day_fr>:#{DAY_FR})    ## use day_name or day_name_fr - why? why not?
       \s+
     (?<day>\d{1,2})
       \.?        # note: make dot optional
       \s+
     (?<month_fr>#{MONTH_FR})   ## use month_name or month_name_fr - why? why not?
       (?=\s+|$|[\]])/x  ## note: allow end-of-string/line too



#
# map table - 1) tag, 2) regex - note: order matters; first come-first matched/served
##  todo/fix: remove (move to attic)???  always use lang specific - why? why not?
FORMATS_ALL = [
  [ DB__DATE_TIME_RE,                '[YYYY_MM_DD_hh_mm]'       ],
  [ DB__DATE_RE,                     '[YYYY_MM_DD]'             ],
  [ DD_MM_YYYY__DATE_TIME_RE,        '[DD_MM_YYYY_hh_mm]'       ],
  [ DD_MM__DATE_TIME_RE,             '[DD_MM_hh_mm]'            ],
  [ DD_MM_YYYY__DATE_RE,             '[DD_MM_YYYY]'             ],
  [ DD_MM__DATE_RE,                  '[DD_MM]'                  ],
  [ FR__DAY_DD_MONTH__DATE_RE,       '[FR_DAY_DD_MONTH]'        ],
  [ EN__DD_MONTH_YYYY__DATE_TIME_RE, '[EN_DD_MONTH_YYYY_hh_mm]' ],
  [ EN__MONTH_DD_YYYY__DATE_TIME_RE, '[EN_MONTH_DD_YYYY_hh_mm]' ],
  [ EN__MONTH_DD__DATE_TIME_RE,      '[EN_MONTH_DD_hh_mm]'      ],
  [ EN__MONTH_DD_YYYY__DATE_RE,      '[EN_MONTH_DD_YYYY]'       ],
  [ EN__MONTH_DD__DATE_RE,           '[EN_MONTH_DD]'            ],
  [ EN__DD_MONTH__DATE_RE,           '[EN_DD_MONTH]'            ],
  [ ES__DD_MONTH__DATE_RE,           '[ES_DD_MONTH]'            ]
]


FORMATS_BASE = [    ### all numbers (no month names or weekday) - find a better name?
  [ DB__DATE_TIME_RE,         '[YYYY_MM_DD_hh_mm]' ],
  [ DB__DATE_RE,              '[YYYY_MM_DD]'       ],
  [ DD_MM_YYYY__DATE_TIME_RE, '[DD_MM_YYYY_hh_mm]' ],
  [ DD_MM__DATE_TIME_RE,      '[DD_MM_hh_mm]'      ],
  [ DD_MM_YYYY__DATE_RE,      '[DD_MM_YYYY]'       ],
  [ DD_MM__DATE_RE,           '[DD_MM]'            ],
]

FORMATS_EN = [
  [ EN__DD_MONTH_YYYY__DATE_TIME_RE, '[EN_DD_MONTH_YYYY_hh_mm]' ],
  [ EN__MONTH_DD_YYYY__DATE_TIME_RE, '[EN_MONTH_DD_YYYY_hh_mm]' ],
  [ EN__MONTH_DD__DATE_TIME_RE,      '[EN_MONTH_DD_hh_mm]'      ],
  [ EN__MONTH_DD_YYYY__DATE_RE,      '[EN_MONTH_DD_YYYY]'       ],
  [ EN__MONTH_DD__DATE_RE,           '[EN_MONTH_DD]'            ],
  [ EN__DD_MONTH__DATE_RE,           '[EN_DD_MONTH]'            ],
]

FORMATS_FR = [
  [ FR__DAY_DD_MONTH__DATE_RE,       '[FR_DAY_DD_MONTH]' ],
]

FORMATS_ES = [
  [ ES__DD_MONTH__DATE_RE,           '[ES_DD_MONTH]' ],
]


FORMATS = {
  en: FORMATS_BASE+FORMATS_EN,
  fr: FORMATS_BASE+FORMATS_FR,
  es: FORMATS_BASE+FORMATS_ES,
}


end  # module DateFormats
