---
layout: post
title:  "Concepts before starting to use reactjs"
date:   2019-10-17 16:06:12 +0200
categories: frontend reactjs react component
---
# What is React JS
ReactJs is an javascript library for building interactive web user interfaces. It provides a framework for frontend developers to divide their web pages into different reusable components.

Back to the old days, we have html static page(or use template engine to create) to be served from an webserver, through http everyone having internet can access the content by using an browser. 

Javascript gives the posibilities for web page developers to add more dynamic parts on a page, such as showing windows, showing dynamic content to html dom and sending ajax request to get extra data without refreshing whole pages.

As more and more contents and interactions grow, web pages become more complex. A lot of software developments will end up with a common question, how to reuse codes instead of copy/paste? In web page development, the question is how to break a page into different part so that we can reuse some of them in different projects.

ReactJS is trying to solve this problem by using component-based development. 

# What's a component in reactjs?
As I mentioned above, how to reuse thing is one of purposes of React and component is the one which will be resued in react.

Function is the initial and basic idea in most of programme world when people don't want to copy/paste pieces of codes around. I think generic functions will need a few parts in (von neumann architecture)[https://en.wikipedia.org/wiki/Von_Neumann_architecture]
- input, 
- output,
- control logic, how to react with input
- local state, where the function can store middle computation result.

In engineering, a function is interpreted as a specific process, action or task that a system is able to perform. 

Not surprised that React will use similar idea. We can consider ReactJS as a system and a component as a function.

From (reactjs offical website)[https://reactjs.org/tutorial/tutorial.html#what-is-react], a component takes in parameters, called props (short for “properties”), and returns a hierarchy of views to display via the render method. The function is something similar as following. 
```
Component A {
    render(props) {
        // variables 
        //... control logic
        return htmlView;
    }
}
```

input is called props
output is the result of render
logic is determined by render method

The above component we defined based on the definition cannot use any other information except the props we give it. We can do a lot of simple things with it, such as rendering a list with different names
```
Component NameList {
    render(props) {
        return <ul><li>props.name</li></ul>
    }
}

ReactRenderEngine.render(NameList,{props={name:"kai"}})
ReactRenderEngine.render(NameList,{props={name:"Erik"}})
ReactRenderEngine.render(NameList,{props={name:"Fabio"}})
```

All of above is what we can imagine before going into real Reactjs implementation.

------
In practice, React does similar implementation. It has a render engine `ReactDOM.render` to render a component into html dom structure. React introduces (element)[https://reactjs.org/docs/rendering-elements.html] concept which is similar as html tags. The (component)[https://reactjs.org/docs/components-and-props.html] specification is as following
```
// Definition function
function Welcome(props) {
  return <h1>Hello, {props.name}</h1>;
}

// ES6 Definition class
class Welcome extends React.Component {
  render() {
    return <h1>Hello, {this.props.name}</h1>;
  }
}

ReactDOM.render(<Welcome name="Sara" />, document.getElementById('root'))
```

One important thing about react component is that * React component is not the same as a function in javascript* even though we can define it by a function. 

A function is finished and forget by system once it's returned. However, a component can have runtime states and keeps track its states until it's deleted by React. A component can have states by setting this.state in their constructors.

I would like to compare react component with a function with a global variable.

```
// javascript function with global variables
functionState=[]
function A() {
    functionState[count]++;
    return <div/>
}

// react component
class A extends React.Component {
  constructor(props) {
    super(props);
    this.state = {count: 0};
  }
  render() {
    return (
      this.state.count++;
      return <div/>
    );
  }
}
``` 

React is a framework to compose complex UIs from small and isolated pieces of code called “components”. It's also a runtime to load, manage component states.

A component in react is a small service and it follows specific lifecycles.