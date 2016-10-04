ActivityThread::main() ->
...
Looper.prepareMainLooper();    //这是在ActivityThread里的特殊的创建Looper的方法，而通常的为为当前线程创建Looper的方法是Looper.prepare()
//用于在主线程中准备Looper的方法prepareMainLooper()与直接的通用的prepare()的特殊之处在于它将刚放进去的当前线程的Looper对象赋给了sMainLooper，即主线程的Looper对象
```java
public static void prepareMainLooper() {
        prepare(false);    // sThreadLocal.set(new Looper(quitAllowed));
        synchronized (Looper.class) {
            if (sMainLooper != null) {
                throw new IllegalStateException("The main Looper has already been prepared.");
            }
            sMainLooper = myLooper();
        }
    }

     /** Initialize the current thread as a looper.
      * This gives you a chance to create handlers that then reference
      * this looper, before actually starting the loop. Be sure to call
      * {@link #loop()} after calling this method, and end it by calling
      * {@link #quit()}.
      */
    public static void prepare() {
        prepare(true);
    }

    private static void prepare(boolean quitAllowed) {
        if (sThreadLocal.get() != null) {
            throw new RuntimeException("Only one Looper may be created per thread");
        }
        sThreadLocal.set(new Looper(quitAllowed));
    }
/**
* Return the Looper object associated with the current thread.  Returns
* null if the calling thread is not associated with a Looper.
*/
public static Looper myLooper() {
    return sThreadLocal.get();
}

private Looper(boolean quitAllowed){
    mQueue = new MessageQueue(quitAllowed);
	mRun = true;
	mThread = Thread.currentThread();
}
```

...

Looper最重要的一个方法是loop()方法，只有调用了loop后，消息循环系统才会真正地起作用。
```java
public static void loop(){
    final Looper me = myLooper();
	if (me == null){
	    throw new RuntimeException("No Loooper; Looper.prepare() wasn't called on this thread.");
	}
	final MessageQueue queue = me.mQueue;
	...
	for(;;){
	    Message msg = queue.next();    //might block
		// No message indicates that the message queue is quitting.
		return;
	}
	...
	msg.target.dispatchMessage(msg);    //这里的msg.target指的就是发送这条消息的Handler对象，这样Handler发送的消息最终又交给它的dispatchMessage方法来处理了。
	//但这里不同的是Handler的dispatchMessage()是在创建Handler时所使用的Looper的Looper.loop()方法中执行的，这样就成功将代码逻辑切换到指定的线程中去执行了。
	...
}
```
那Handler的dispatchMessage()是怎样的呢？
```java
    /**
     * Subclasses must implement this to receive messages.
     */
    public void handleMessage(Message msg) {
    }
    
    /**
     * Handle system messages here.
     */
    public void dispatchMessage(Message msg) {
        if (msg.callback != null) {
            handleCallback(msg);
        } else {
            if (mCallback != null) {
                if (mCallback.handleMessage(msg)) {
                    return;
                }
            }
            handleMessage(msg);    //即最终还是调动handlerMessage()来处理接收到的消息，不过这个方法得创建Handler时由程序员自己复写。
        }
    }
```



当在Activity中
```java
private Handler handler = new Handler();
```
时，

```java
public Handler(){
    ...
	mLooper = Looper.myLooper();    //取出由ActivityThread类的main()中prepare(false)之后存储在sThreadLocal中的mLooper对象，然后赋值给Handler对象的mLooper，即，拿到与主线程关联的Looper对象
	mQueue = mLooper.mQueue;    //将mLooper中的mQueue(MessageQueue)对象赋值给Handler对象的mQueue，之后Handler就可以把发送的消息存储在这个MessageQueue之中
	mCallback = null;
}
```

在Activity中调用handler对象的
`handler.sendMessage(...)`;
最终调用的是：
```java
    public boolean sendMessageAtTime(Message msg, long uptimeMillis) {
        MessageQueue queue = mQueue;
        if (queue == null) {
            RuntimeException e = new RuntimeException(
                    this + " sendMessageAtTime() called with no mQueue");
            Log.w("Looper", e.getMessage(), e);
            return false;
        }
        return enqueueMessage(queue, msg, uptimeMillis);
    }
	
	private boolean enqueueMessage(MessageQueue queue, Message msg, long uptimeMillis) {
        msg.target = this;    //也就是说，这个消息是发送给Handler这个对象自己的！！！
        if (mAsynchronous) {
            msg.setAsynchronous(true);
        }
        return queue.enqueueMessage(msg, uptimeMillis);    //作用就是往消息队列中插入一条消息(单链表的插入操作)
    }
```