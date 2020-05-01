---
layout: post
title:  "Start a nodejs project and publish it into public npm registry"
date:   2020-05-01 21:56:21 +0200
categories: Nodejs starter
---

This is all about the basic steps to start a npm project and publish it into [npmjs](https://www.npmjs.com/)

Npmjs is a public npm registry which is managing packages. Anyone can register an account and publish his or her package to share with others. It's free if you are only about publishing publich packages and can be accessed by anyone. Paid features can be found [here](https://www.npmjs.com/products)

## Register an account 
To manage your own packages, an account is required in [npmjs](https://www.npmjs.com/)

## Create a project
Simply create a folder in your local machine and run npm init to start a npm project
```bash
$ mkdir node_starter && cd node_starter
node_starter$ npm init --scope=kaichu

package name: (@kaichu/node_starter) 
version: (1.0.0) 
git repository: 
keywords: 
license: (ISC) 
About to write to /Users/kaichu/Workspace/Dev/js/poc/node_in_deep/node_starter/package.json:
{
  "name": "@kaichu/node_starter",
  "version": "1.0.0",
  "description": "A starter demo",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "Kai Chu",
  "license": "ISC"
}
```

## Create the index.js file 
which is the main entrypoint of the package as specified in the package key "main"
```bash
node_starter$ touch index.js
node_starter$ echo 'console.log("hi nodejs")' >> index.js
```

## Login the registry from command
Looks good enough to try out the publish, before a publish, you need to login the the registy in your local command. Run following command and fill in your username and password you have setup in the Step 1
```bash
$ npm login
```
> which actually create a authToken in your home ~/.npmrc file
```
$ cat ~/.npmrc 
//registry.npmjs.org/:_authToken="xxxxx-xxxx-xxx"
```

## Publish your first npm package 
Make sure you are in the node_starter dir and run publich. the --access will tell npm registry if it's a public or restricted package. 
Since we are not paying, only public options are useful.
```
$ npm publish --access=public
```

## Check the published result 
You should have got an email and tell you haved published your package Go to npm regisry and 
```
//Email
Successfully published @kaichu/node_starter@1.0.0

// Npm registry 
Click your profile pic -> packages, node_starter is ready for you there.

```
![NPM packages](/assets/npm_packages.png)

## Use your package 
Since the package is published in npm registery, now you can use your `npm i` to install it. 
```bash
$ npm i @kaichu/node_starter
``` 

## Tag your published package
When publishing a package, npm will add a tag `latest` to your package which can be seen in npmjs as following
![Latest tag default](/assets/npm_before_tag.png)

When publish packages, we can add extra options --tag to add new tag to a publish. 
```bash
npm publish --access=public --tag=dev
```

However, since we have publihed the package, in default, we cannot publish the same version again. We can use 
another separate npm cli to add dev tag.
```
$ npm dist-tag add @kaichu/node_starter@1.0.0 dev
$ npm dist-tag ls @kaichu/node_starter@1.0.0
```
The result will be shown in npmjs as well.
![Latest tag default](/assets/npm_after_tag.png)

## References
1. [my node_starter](https://www.npmjs.com/package/@kaichu/node_starter)
