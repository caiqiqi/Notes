# Android之Service

## Overview:
Note that Services,like other applicaiton objects,run in the main thread of their hosting process.This means that ,if your service is going to do any CPU intensive(such as MP3 playback) or blocking(such as networking)operations,it should spawn its own thread in which to do that work.

Two forms
- Started
A service is "started" when an application component(such as an activity) starts it by calling `startService()`.Once started,a service can run in the background `indefinitely`,even if the component that started it is destroyed.</br>
Usually,a `started` service performs a single operation and `does not return a result to the caller`.For example,it might download or upload a file over the network.When the operation is done,the service should stop itself.
- Bound
...

```
Caution:
A service runs in the main thread of its hosting process-the service does NOT create its own thread and does NOT run in a separate process(unless you specify otherwise)
```

If a component starts the service by calling `startService()`(which result in a call to `onStartCommand()`) then the service remains running until it stops itself by `stopSelf()` or another component stops it by calling `stopService()`.

## onCreate()

The system calls this method when the service is first created, to perform one-time setup procedures (before it calls either `onStartCommand()` or `onBind()` ). If the service is already running, this method is not called.

## onDestroy()

The system calls this method when the service is no longer used and is being destroyed. Your service should implement this to clean up any resources such as <b>threads</b>, <b>registered listeners</b>, <b>receivers</b>, etc. This is the last call the service receives.


# IntentService extends Service

This is a subclass of Service that uses a worker thread to handle all start requests, one at a time. This is the BEST option if you don't require that your service handle multiple requests simultaneously. All you need to do is implement `onHandleIntent()`, which receives the intent for each start request so you can do the background work.</br>

That's all you need:a constructor and an implementation of `onHandleIntent()`
