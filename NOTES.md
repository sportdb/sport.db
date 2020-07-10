# Notes

## gems / libs to push publish

- [ ] sportdb-langs
  - up pt.yml




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


## Command Line Suites

### Commander

#### Docu / Links

- [Rubygems](https://rubygems.org/gems/commander)
  - Runtime Dependencies: 1 - highline ~> 1.6.11
  - Last Update: Dec/2012
  - Downloads: > 10,000
- [Official Gem Docu](http://visionmedia.github.com/commander)
- [Github Site 'n' Readme](https://github.com/visionmedia/commander)
- [Rdoc](http://rdoc.info/github/visionmedia/commander/master/frames)

Features:

- Parses options using OptionParser
- Optional default sub-command when none is present

Source Code Examples:

- [jekyll](https://github.com/mojombo/jekyll/blob/master/bin/jekyll)
- [commander](https://github.com/visionmedia/commander/blob/master/bin/commander)
- [pomo](https://github.com/visionmedia/pomo/blob/master/bin/pomo)

Source Code Examples for Options:

- [pomo](https://github.com/visionmedia/pomo/blob/master/lib/pomo/configuration.rb)

Some more gems depending on commander:

rhc, jspec, bind, rehabilitate, cloudsync, shnell, rutty,
grapevine, uki, microcloud, html_email_creator,
md_splitter, abak-flow, rid-core


### Alternatives

#### CRI - stands for ??
- [Github Site](https://github.com/ddfreyne/cri)

[ ] todo add rubygems link
  - Runtime Dependencies: ??
  - Last Update: ??
  - Downloads: > ??

Used by nanoc (static site generator)

#### GLI - stands for ??

- [Official Project Docu](http://davetron5000.github.com/gli)

Used by: showoff

[ ] todo add rubygems link
  - Runtime Dependencies: ??
  - Last Update: ??
  - Downloads: > ??



Features:

- Parses options using OptionParser

Minus:

Docu for default command says:

> Note that if you use this, you won't be able to pass arguments, flags, or switches
> to the command when run in default mode.  All flags and switches are treated
> as global, and any argument will be interpretted as the command name and likely
> fail.


### Links

- [Command Line Gem Options](http://www.awesomecommandlineapps.com/gems.html)
- [Command Plugin "Architecture - Q on Stackoverflow"](http://stackoverflow.com/questions/7251580/how-can-i-build-a-modular-command-line-interface-using-rubygems)


### Todos

- [ ] check gem - what is it using? hand rolled? w/ optparser?
- [ ] add link to cli rubytoolbox category
- [ ] move notes to rubybook (single-source, all in one place)
