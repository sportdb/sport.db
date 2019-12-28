# encoding: utf-8


module DateFormats

# e.g. 2012-09-14 20:30   => YYYY-MM-DD HH:MM
#  note: allow 2012-9-3 7:30 e.g. no leading zero required
# regex_db

##  todo/fix: add rule with allowed / separator (e.g. 2019/12/11)
##    BUT must be used in all following case too (NO mix'n'match allowed e.g. 2019-11/12)
DB__DATE_TIME_RE = /\b
               (?<year>\d{4})
                 -
               (?<month>\d{1,2})
                 -
               (?<day>\d{1,2})
                \s+
               (?<hours>\d{1,2})
                 [:.hH]
               (?<minutes>\d{2})
                \b/x

# e.g. 2012-09-14    => YYYY-MM-DD
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
                          [:.hH]
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
                         [:.hH]
                      (?<minutes>\d{2})
                        \b/x

# e.g. 14.09.2012  => DD.MM.YYYY
# regex_de3
DD_MM_YYYY__DATE_RE = /\b
                  (?<day>\d{1,2})
                    \.
                  (?<month>\d{1,2})
                    \.
                  (?<year>\d{4})
                    \b/x

# e.g. 14.09.  => DD.MM. w/ implied year
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
#   or 12 May 2013 14h00
EN__DD_MONTH_YYYY__DATE_TIME_RE = /\b
              (?<day>\d{1,2})
                 \s
              (?<month_name>#{MONTH_EN})
                 \s
              (?<year>\d{4})
                 \s+
              (?<hours>\d{1,2})
                [:hH]
              (?<minutes>\d{2})
                \b/x

# e.g. 12 May  => D|DD.MMM  w/ implied year
EN__DD_MONTH__DATE_RE = /\b
              (?<day>\d{1,2})
                 \s
              (?<month_name>#{MONTH_EN})
                 \b/x

# e.g. Fri Aug/9  or Fri Aug 9
#      Fri, Aug/9 or Fri, Aug 9
EN__DAY_MONTH_DD__DATE_RE = /\b
     (?<day_name>#{DAY_EN})
        ,?   # note: allow optional comma
        \s
     (?<month_name>#{MONTH_EN})
        (?: \/|\s )
     (?<day>\d{1,2})
        \b/x

# e.g.  Jun/12 2011 14:00  or
#       Jun 12, 2011 14:00 or
#       Jun 12, 2011 14h00
EN__MONTH_DD_YYYY__DATE_TIME_RE = /\b
                 (?<month_name>#{MONTH_EN})
                   (?: \/|\s )
                 (?<day>\d{1,2})
                   ,?   # note: allow optional comma
                   \s
                 (?<year>\d{4})
                   \s+
                 (?<hours>\d{1,2})
                   [:hH]
                 (?<minutes>\d{2})
                   \b/x

# e.g.  Jun/12 14:00  w/ implied year H|HH:MM
#   or  Jun 12 14h00
EN__MONTH_DD__DATE_TIME_RE = /\b
                 (?<month_name>#{MONTH_EN})
                   (?: \/|\s )
                 (?<day>\d{1,2})
                   \s+
                 (?<hours>\d{1,2})
                   [:hH]
                 (?<minutes>\d{2})
                   \b/x

# e.g. Jun/12 2013
#   or Jun 12 2013
#   or Jun 12, 2013
EN__MONTH_DD_YYYY__DATE_RE = /\b
              (?<month_name>#{MONTH_EN})
                 (?: \/|\s )
              (?<day>\d{1,2})
                 ,?   # note: allow optional comma
                 \s
              (?<year>\d{4})
                \b/x

# e.g.  Jun/12  w/ implied year and implied hours (set to 12:00)
#  note: allow space too e.g Jun 12   -- check if conflicts w/ other formats??? (added for rsssf reader)
#   -- fix: might eat french weekday mar 12  is mardi (mar)  !!! see FR__ pattern
#  fix: remove  space again for now - and use simple en date reader or something!!!
##  was [\/ ]   changed back to \/

## check if [\/ ] works!!!! in \x mode ??
EN__MONTH_DD__DATE_RE = /\b
                 (?<month_name>#{MONTH_EN})
                    (?: \/|\s )
                 (?<day>\d{1,2})
                   \b/x




# e.g.  12 Ene  w/ implied year
ES__DD_MONTH__DATE_RE = /\b
                 (?<day>\d{1,2})
                   \s
                 (?<month_name>#{MONTH_ES})
                   \b/x

# e.g.  Vie 12 Ene  w/ implied year
ES__DAY_DD_MONTH__DATE_RE = /\b
                 (?<day_name>#{DAY_ES})
                   \.?        # note: make dot optional
                   \s
                 (?<day>\d{1,2})
                   \s
                 (?<month_name>#{MONTH_ES})
                   \b/x

# e.g. Sáb 5 Ene 19:30
ES__DAY_DD_MONTH__DATE_TIME_RE = /\b
                 (?<day_name>#{DAY_ES})
                   \.?        # note: make dot optional
                   \s
                 (?<day>\d{1,2})
                   \s
                 (?<month_name>#{MONTH_ES})
                   \s+
                 (?<hours>\d{1,2})
                   [:hH]
                 (?<minutes>\d{2})
                   \b/x


# e.g. Vie. 16.8. or  Sáb. 17.8.
#  or  Vie 16.8.  or  Sáb 17.8.
ES__DAY_DD_MM__DATE_RE = /\b
        (?<day_name>#{DAY_ES})
           \.?        # note: make dot optional
           \s
        (?<day>\d{1,2})
           \.
        (?<month>\d{1,2})
           \.
          (?=\s+|$|[\]])/x  ## note: allow end-of-string/line too/x


# e.g. Sab. 24.8. or Dom. 25.8.
#  or  Sab 24.8.  or Dom 25.8.
IT__DAY_MM_DD__DATE_RE = /\b
        (?<day_name>#{DAY_IT})
           \.?        # note: make dot optional
           \s
        (?<day>\d{1,2})
           \.
        (?<month>\d{1,2})
           \.
          (?=\s+|$|[\]])/x  ## note: allow end-of-string/line too/x


# e.g. Ven 8 Août  or [Ven 8 Août] or Ven 8. Août  or [Ven 8. Août]
### note: do NOT consume [] in regex (use lookahead assert)
FR__DAY_DD_MONTH__DATE_RE = /\b
     (?<day_name>#{DAY_FR})
       \s+
     (?<day>\d{1,2})
       \.?        # note: make dot optional
       \s+
     (?<month_name>#{MONTH_FR})
       \b/x


# e.g. 29/03/2003 - Sábado  or
#      29/3/2003 Sábado
PT__DD_MM_YYYY_DAY__DATE_RE = /\b
        (?<day>\d{1,2})
           \/
        (?<month>\d{1,2})
           \/
        (?<year>\d{4})
           \s+
           (?: -\s+ )?   # note: make dash separator (-) optional
        (?<day_name>#{DAY_PT})
       \b/x

# e.g. Sáb, 13/Maio or Qui, 08/Junho
#  or  Sáb 13 Maio or Qui 8 Junho
PT__DAY_DD_MONTH__DATE_RE = /\b
        (?<day_name>#{DAY_PT})
           \.?        # note: make dot optional
           ,?         # note: allow optional comma too
           \s
        (?<day>\d{1,2})
           (?: \/|\s )
        (?<month_name>#{MONTH_PT})
       \b/x

# e.g. Sáb, 29/07 or  Seg, 31/07
#      Sáb 29/07  or  Seg 31/07
PT__DAY_DD_MM__DATE_RE = /\b
        (?<day_name>#{DAY_PT})
           \.?        # note: make dot optional
           ,?         # note: allow optional comma too
           \s
        (?<day>\d{1,2})
           \/
        (?<month>\d{1,2})
       \b/x





# e.g. Fr. 26.7. or  Sa. 27.7.
#  or  Fr 26.7.  or  Sa 27.7.
#  or  Fr, 26.7. or  Sa, 27.7.
DE__DAY_MM_DD__DATE_RE = /\b
        (?<day_name>#{DAY_DE})
           \.?        # note: make dot optional
           ,?         # note: allow optional comma too
           \s
        (?<day>\d{1,2})
           \.
        (?<month>\d{1,2})
           \.
          (?=\s+|$|[\]])/x  ## note: allow end-of-string/line too/x



#############################################
# map tables - 1) regex,  2) tag - note: order matters; first come-first matched/served

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
  [ EN__DAY_MONTH_DD__DATE_RE,       '[EN_DAY_MONTH_DD]',       ],
  [ EN__MONTH_DD__DATE_RE,           '[EN_MONTH_DD]'            ],
  [ EN__DD_MONTH__DATE_RE,           '[EN_DD_MONTH]'            ],
]

FORMATS_FR = [
  [ FR__DAY_DD_MONTH__DATE_RE,       '[FR_DAY_DD_MONTH]' ],
]

FORMATS_ES = [
  [ ES__DAY_DD_MONTH__DATE_TIME_RE,  '[ES_DAY_DD_MONTH_hh_mm]' ],
  [ ES__DAY_DD_MONTH__DATE_RE,       '[ES_DAY_DD_MONTH]' ],
  [ ES__DD_MONTH__DATE_RE,           '[ES_DD_MONTH]' ],
  [ ES__DAY_DD_MM__DATE_RE,          '[ES_DAY_DD_MM]' ],
]


FORMATS_PT = [
  [ PT__DD_MM_YYYY_DAY__DATE_RE,     '[PT_DD_MM_YYYY_DAY]' ],
  [ PT__DAY_DD_MONTH__DATE_RE,       '[PT_DAY_DD_MONTH]' ],
  [ PT__DAY_DD_MM__DATE_RE,          '[PT_DAY_DD_MM]' ],
]

FORMATS_DE = [
   [ DE__DAY_MM_DD__DATE_RE,         '[DE_DAY_MM_DD]' ],
]

FORMATS_IT = [
   [ IT__DAY_MM_DD__DATE_RE,          '[IT_DAY_MM_DD]' ],
]


FORMATS = {
  en: FORMATS_EN + FORMATS_BASE,
  fr: FORMATS_FR + FORMATS_BASE,
  es: FORMATS_ES + FORMATS_BASE,
  pt: FORMATS_PT + FORMATS_BASE,
  de: FORMATS_DE + FORMATS_BASE,
  it: FORMATS_IT + FORMATS_BASE,
}

end  # module DateFormats
