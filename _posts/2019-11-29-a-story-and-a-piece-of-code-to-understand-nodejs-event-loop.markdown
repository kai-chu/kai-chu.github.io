---
layout: post
title:  "A story and a piece of code to understand nodejs event loop"
date:   2019-11-29 16:00:54 +0100
categories: nodejs 'event loop' setImmediate setTimeout Promise
---
# A story 
Imagine the code you want to run is a king and node is the army of servants.
The day starts by one servant waking up the king and asking him if he needs anything. The king gives the servant a list of tasks and goes back to sleep a little longer. The servant now distributes those tasks among his colleagues and they get to work.
Once a servant finishes a task, he lines up outside the kings quarter to report. The king lets one servant in at a time, and listens to things he reports. Sometimes the king will give the servant more tasks on the way out.
Life is good, for the king's servants carry out all of his tasks in parallel, but only report with one result at a time, so the king can focus.

# Callback programming model in nodejs
Request an action and register a callback which will be called when the action has been done.
The first request is from node main.js, 
1. all function calls will be done in the current phase
2. any async function call (await on async, async.then) will register a callback in the pending callbacks queue
3. any timer will be registered in the timers queue
4. any I/O events from OS level will be listened in poll phases, (timeout and count limitation) 
5. any setImmediate will be run in check, right after next event loop
6. any close callbacks 
7. checks if it is waiting for any asynchronous I/O or timers and shuts down cleanly if there are not any
8. nextTickQueue will be processed after the current operation is completed, regardless of the current phase of the event loop

```

   ┌───────────────────────────┐
┌─>│           timers          │
│  └─────────────┬─────────────┘
│  ┌─────────────┴─────────────┐
│  │     pending callbacks     │
│  └─────────────┬─────────────┘
│  ┌─────────────┴─────────────┐
│  │       idle, prepare       │
│  └─────────────┬─────────────┘      ┌───────────────┐
│  ┌─────────────┴─────────────┐      │   incoming:   │
│  │           poll            │<─────┤  connections, │
│  └─────────────┬─────────────┘      │   data, etc.  │
│  ┌─────────────┴─────────────┐      └───────────────┘
│  │           check           │
│  └─────────────┬─────────────┘
│  ┌─────────────┴─────────────┐
└──┤      close callbacks      │
   └───────────────────────────┘

```

# nextTick, setImmediate and setTimeout
A function passed to process.nextTick() is going to be executed on the current iteration of the event loop, after the current operation ends.
Any function passed as the setImmediate() argument is a callback that’s executed in the next iteration of the event loop.
Any function passed as the setTimeout() argument is a callback that's executed in the next iteration of the event loop if the time duration has been met

# Show me the code 
I create a js file and show u how it works. 

```
async function bunchWorkAsync() {
    for (let x = 0; x < 20; x++) {
        setImmediate(() => console.log("set immediate" + x));
        setTimeout(() => console.log("set timeout" + x), 0);
        new Promise((resolve, reject) => { console.log('current phase'); resolve('promise callback ' + x) }).then(v => console.log(v)).catch(r => console.log(r));
        process.nextTick(() => { console.log("set nexttick" + x) });
        console.log('register ' + x)
    }
    return 0;
}

console.log('current phase is started >>>>>> '); 
bunchWorkAsync().then(v => console.log(v+ ' is resolved in the end of callback queue'));
setImmediate(() => console.log("set immediate in the end"));
console.log('current phase is done >>>>>> ');
```
when I run the js file, event loop starts to work with my current function(node file.js will run all sync and async functions and register all async callbacks in some queues)
So the running sequence will be explained as following:
1. console.log
console.log('current phase is started >>>>>> '); 
2. bunchWorkAsync()
we go into the loop,
2.1 setImmediate(() => console.log("set immediate" + x));
we register a callback in the check phase in next event loop
2.2 setTimeout(() => console.log("set timeout" + x), 0);
we register a callback in the timers in next event loop
2.3 new Promise((resolve, reject) ...)
Run console.log('current phase')
we register a callback by Promise(same as a async function) in the callback phase
2.4  process.nextTick(() => { console.log("set nexttick" + x) });
we register a callback right after the current operation is done, should be run in current event loop
2.5 console.log('register ' + x)
we run the log in current phase
2.6 return 0, since we run the bunchWorkAsync with callback
we register a callback in next event loop 
3. setImmediate(() => console.log("set immediate in the end"));
we add a callback in the check phase in next event loop
4. console.log('current phase is done >>>>>> ');
we run the command in current operation

Then we can think everything in the event loop as following
Current loop
1. current operation 
   running all command
2. next tick queue
   20 callbacks setup by process.nextTick(() => { console.log("set nexttick" + x) });

Next event loop
1. timers queue
   20 callbacks setup by setTimeout()
2. pending callbacks queue
   20 callbacks setup by new Promise().then()
   1 callback setup by bunchWorkAsync().then()
3. check 
   20 callbacks setup by setImmediate()
   1 callback setup by setImmediate(() => console.log("set immediate in the end"));

So in theory, in the end, you should expect the running sequence as following
1 current phase output
current phase is started >>>>>> 
20 times 'current phase'
20 times 'register ' + x
current phase is done >>>>>> 
2. nextTick 
20 times 'set nexttick' + x
3. timers
queues stay
4. callbacks queue
20 times 'promise callback'
v+ ' is resolved in the end of callback queue'
5. poll
hi OS, I tell u to print my logs, it takes 20ms; 
OS said yes. it takes 2ms to get the message into node. (I think callback run in libuv?)
after 22ms ...
Oh yeah, I need to check with timers, they may ask to do something now
Of course, 
20 times 'set timeout' is in the queue for a while
jump into timers tasks

5. check phase
20 times 'set immediate'
set immediate in the end

```
$ node examples/event-loop.js
current phase is started >>>>>>
current phase
register 0
current phase
register 1
current phase
register 2
current phase
register 3
current phase
register 4
current phase
register 5
current phase
register 6
current phase
register 7
current phase
register 8
current phase
register 9
current phase
register 10
current phase
register 11
current phase
register 12
current phase
register 13
current phase
register 14
current phase
register 15
current phase
register 16
current phase
register 17
current phase
register 18
current phase
register 19
current phase is done >>>>>>
set nexttick0
set nexttick1
set nexttick2
set nexttick3
set nexttick4
set nexttick5
set nexttick6
set nexttick7
set nexttick8
set nexttick9
set nexttick10
set nexttick11
set nexttick12
set nexttick13
set nexttick14
set nexttick15
set nexttick16
set nexttick17
set nexttick18
set nexttick19
promise callback 0
promise callback 1
promise callback 2
promise callback 3
promise callback 4
promise callback 5
promise callback 6
promise callback 7
promise callback 8
promise callback 9
promise callback 10
promise callback 11
promise callback 12
promise callback 13
promise callback 14
promise callback 15
promise callback 16
promise callback 17
promise callback 18
promise callback 19
0 is resolved in the end of callback queue
set timeout0
set timeout1
set timeout2
set timeout3
set timeout4
set timeout5
set timeout6
set timeout7
set timeout8
set timeout9
set timeout10
set timeout11
set timeout12
set timeout13
set timeout14
set timeout15
set timeout16
set timeout17
set timeout18
set timeout19
set immediate0
set immediate1
set immediate2
set immediate3
set immediate4
set immediate5
set immediate6
set immediate7
set immediate8
set immediate9
set immediate10
set immediate11
set immediate12
set immediate13
set immediate14
set immediate15
set immediate16
set immediate17
set immediate18
set immediate19
set immediate in the end
```

# References 
- [nodejs event loop](https://nodejs.org/en/docs/guides/event-loop-timers-and-nexttick) 
- [a storty](https://stackoverflow.com/questions/45566463/node-js-event-loop-understanding-with-a-diagram)
