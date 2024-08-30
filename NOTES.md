# Notes



## Dev Tips

### Countries

To synch countries list use (in fifa and test). Use:

```
cp fifa\config\countries.txt test\world
```



### Hoe

### Configure Manifest Excludes

To configure files to exclude from the `check_manifest` task
open `~/.hoerc` and edit the line starting with `exclude:` e.g.

    exclude: !ruby/regexp /tmp$|(attic\/\S+)|NOTES\.md|(sandbox\/\S+)|TODO\.markdown...

