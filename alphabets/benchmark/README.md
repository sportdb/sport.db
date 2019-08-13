# Benchmarks

## Unaccent

Remove accent and diacritic marks from characters with `unaccent`

```
text=>AÄ OÖ UÜ aä oö uü<, n=200000:
                         user     system      total        real
each_char            1.484000   0.000000   1.484000 (  1.473911)
each_char_v2         1.313000   0.000000   1.313000 (  1.330767)
each_char_reduce     1.719000   0.000000   1.719000 (  1.720699)
each_char_reduce_v2  1.546000   0.000000   1.546000 (  1.534633)
gsub                 1.750000   0.000000   1.750000 (  1.754240)
scan                 2.344000   0.000000   2.344000 (  2.343913)

text=>A O U a o u<, n=200000:
                          user     system      total        real
each_char            0.813000   0.000000   0.813000 (  0.826428)
each_char_v2         0.734000   0.000000   0.734000 (  0.756349)
each_char_reduce     1.031000   0.000000   1.031000 (  1.031800)
each_char_reduce_v2  1.141000   0.000000   1.141000 (  1.268132)
gsub                 1.063000   0.000000   1.063000 (  1.059380)
scan                 1.546000   0.000000   1.546000 (  1.559567)

