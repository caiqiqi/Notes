# Handler的sendMessage()方法探秘

今天看《疯狂Android讲义》里面有一段讲解多任务Socket通信（服务端Java，客户端Android）的一些基本套路。要用到`Handler`,`Looper`。我对这个`Handler`的`sendMessage()`方法有些迷糊，不知道这个所谓的send到底是send到哪里。于是看看`android.os.Handler`的源码`Handler.java`。</br>

``` java
public final boolean sendMessage(Message msg)
    {
        return sendMessageDelayed(msg, 0);
    }
```
即首先调用的其实是`sendEmptyMessageDelayed(int what, long delayMillis)` 于是看看这个方法，</br>

``` java
public final boolean sendEmptyMessageDelayed(int what, long delayMillis) {
        Message msg = Message.obtain();
        msg.what = what;
        return sendMessageDelayed(msg, delayMillis);
    }
```
即调用的其实是`sendMessageDelayed(Message msg, long delayMillis)` 于是再看看这个方法，</br>

``` java
public final boolean sendMessageDelayed(Message msg, long delayMillis)
    {
        if (delayMillis < 0) {
            delayMillis = 0;
        }
        return sendMessageAtTime(msg, SystemClock.uptimeMillis() + delayMillis);
    }
```
发现它调用的又是`sendMessageAtTime(Message msg, long uptimeMillis)` 于是再看看这个方法，</br>

``` java
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
```
发现它调用的又是这个方法`enqueueMessage(MessageQueue queue, Message msg, long uptimeMillis)` </br>
注意是private的哦~ </br>

``` java
private boolean enqueueMessage(MessageQueue queue, Message msg, long uptimeMillis) {
        msg.target = this;
        if (mAsynchronous) {
            msg.setAsynchronous(true);
        }
        return queue.enqueueMessage(msg, uptimeMillis);
    }
```
所以发现其实到最后就是把向`MessageQueue`中增加一条`Message` </br>
所以由于主线程中有一个`Looper`，可以循环取出这个`Message`，于是就可以在主线程的`Handler`中处理这个`Message`了。</br>
另外由于 `Handler` 每次 `sendMessage()` 时，都会将一个消息送到一个消息对队列中，所以每次必须是一个新的 `Message` 对象才行

