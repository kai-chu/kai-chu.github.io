---
layout: post
title:  "Something in mind when creating web pages"
date:   2019-10-22 17:32:10 +0200
categories: frontend javascript html SPA Isomorphic
---
I've never worked as a web frontend developer in any company, however I have to work with it with my own project all the time. 
> It's so interesting when I try to search html editor that dreamweaver hasn't been an option any more in most of the blogs. In 2009, when I learnt html tags, I thought everyone would use it in the future.

Anyway, it always helps to keep html definition in mind.
> HTML is the standard markup language for documents designed to be displayed in a web browser. It can be assisted by technologies such as Cascading Style Sheets (CSS) and scripting languages such as JavaScript. Web browser receive html documents from a web browser.

Nowadays, it seems the sauce is better than the fish. JavaScript and CSS are taking more responsibilities than html itself, e.g. popular frameworks reactjs or angularjs. 

I try to think about different ways of how a html page can be created and served. This is a simple ![overview](/assets/SSRandCSR.png)

Initially in (1), html pages are static and be served from web server directly. Smart developers start to use template in the webserver and make it a lit bit reusable.

JavaScript is introduced in (2) to make web pages with animations or doing ajax request to render part of pages. It's a big applause if u can submit a post request and update a page without refreshing the whole pages. Dynamically adding html elements with piece of data using jQuery in the browser is popular. Html still accounts for larger proportion of a project, I would say. Server template engine is heavily used to generate html pages with data.

JavaScript is dominant in (3), putting piece of data with js to be rendered is dissatisfied. JS developers create compelling frameworks which can render all data which is required by a page and replace template engine such as [JSP](https://en.wikipedia.org/wiki/JavaServer_Pages). A index html page is sent to a client browser with a bundle of js files. When all files are fetched, browser will be ready to show a page as a [Single-page Application(SPA)](https://en.wikipedia.org/wiki/Single-page_application). Data will be fetched and rendered when the user interacts. When I start to use ReactJS, I think it definitly belongs to this phase especially be using with nodejs app. It requires a client to have good network connection to do all the requests to different servers.

Empty pages or slow client loading, SEO rendering. Problems exist in phase (3) when it comes to those questions. Client has to wait for loading the who SPA in the first access. A blend solution of (2) and (3) which is called [Isomorphic Web Application](https://en.wikipedia.org/wiki/Isomorphic_JavaScript), an isomorphic app is a web app that blends a server-rendered web app with a single-page application. Someone defined it as codes can be run in both client and server side. I prefer to defined as a SPA with the feature that its first html page can be rendered in server side.
When server receives a page request, it shall request data by itself, render a page and send it to client, subsequent client request will be handled by the client it self as a SPA. 


Good posts to explain Single Page Application and Isomorphic Web Application

- [Toptal.com: client side vs server sdie pre rendering](https://www.toptal.com/front-end/client-side-vs-server-side-pre-rendering)

- [Medium ElyseKoGo](https://medium.com/@ElyseKoGo/an-introduction-to-isomorphic-web-application-architecture-a8c81c42f59)




