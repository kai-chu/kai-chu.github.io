---
layout: post
title:  "Simple bash to create a blog in jekyll minima"
date:   2019-09-21 14:56:34 +0200
categories: developer tools bash
---
Just start to use Jekyll to manage my personal blog, not sure if there's a tool to create a blog in the basice theme minima, to make my life easier, I decide to add a simple bash scripts to add a post easily.

Steps to create a post in minima:
1. Add a file in _posts folder
2. Name the file with YYYY-MM-DD-my-title-is-here.markdown
3. Copy paste the front matter from an old blog 
4. Change the title of to "My title is here"
5. Change the date and time 
6. Start to think about my content

I think a basic bash will save my life and it's worthy to add it, what I want the script to do is receiving a a list of words, finishing all above steps and generating a file with basic front matter
```
./new.sh my title is here
```

# Date and time
We need a time format `2019-09-21 14:56:34 +0200` in the blog front matter, which can be generated using following bash date command
```
blogDate=`date "+%F %T %z"`
```
We need a date format `2019-09-21` which is also easy in bash, %F is refered by this [turorial](https://www.tutorialkart.com/bash-shell-scripting/bash-date-format-options-examples/) 
```
filedate=`date +%F`
```

# Title and filename
The input from the command will be all the words of the title. To generate a blog file, we need to convert all letters into lower case and add a hyphen in between, which is quite easy to be done by `tr` [command](https://ss64.com/bash/tr.html) 
```
lowcase=$( echo $title | tr '[A-Z]' '[a-z]')
formatTitle=$( echo $lowcase | tr '[[:blank:]]' '-' )
```

However, in bash 3, seems we don't have a good choice to make the first letter of a string upper case and welcome anyone to give me a suggest if you konw. I agree with [Michael's suggestion](https://stackoverflow.com/questions/12487424/uppercase-first-character-in-a-variable-with-bash) in stackoverflow and using following way to archive it. Basically, get the first letter in the string by using [string manipulation](https://www.tldp.org/LDP/abs/html/string-manipulation.html) and replace it with upper case. Then we combine it with the rest of other charaters in the string.
```
blogTitle="$( echo ${lowcase:0:1} | tr '[a-z]' '[A-Z]' )${lowcase:1}"
```

Then we can create the file and output the front matter with [here document](https://en.wikipedia.org/wiki/Here_document)
```
# Create a file with the filename
touch $filename

# Add some common front matter
cat > $filename << EOF
---
layout: post
title:  "${blogTitle}"
date:   $blogDate
categories: 
---
EOF
```

## To generate a new post 
```
$ cd _posts/
$ ./new.sh my new post idea is ready
## > 2019-09-21-my-new-post-idea-is-ready.markdown has be generated
```
![The result of the bash scripts](/assets/bashnewblog.png)


[Script source file](https://github.com/kai-chu/kai-chu.github.io/tree/master/_posts/new.sh)
