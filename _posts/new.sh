#!/bin/bash 
# -e  Exit immediately if a command exits with a non-zero status.
set -e 

# Step to make every letter in lower case
title="$@"
lowcase=$( echo $title | tr '[A-Z]' '[a-z]')

# Replace space with a hyphen 
formatTitle=$( echo $lowcase | tr '[[:blank:]]' '-' )

# Make the first letter upper case
blogTitle="$( echo ${lowcase:0:1} | tr '[a-z]' '[A-Z]' )${lowcase:1}"

# Generate the time 
blogDate=`date "+%F %T %z"`

# Create a filename of the blog
filename=`date +%F-$formatTitle.markdown`

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

# Notify the result
echo "${filename} has be generated"