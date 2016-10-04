ActivityThread::main() ->
...
Looper.prepareMainLooper();    //������ActivityThread�������Ĵ���Looper�ķ�������ͨ����ΪΪ��ǰ�̴߳���Looper�ķ�����Looper.prepare()
//���������߳���׼��Looper�ķ���prepareMainLooper()��ֱ�ӵ�ͨ�õ�prepare()������֮�����������շŽ�ȥ�ĵ�ǰ�̵߳�Looper���󸳸���sMainLooper�������̵߳�Looper����
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

Looper����Ҫ��һ��������loop()������ֻ�е�����loop����Ϣѭ��ϵͳ�Ż������������á�
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
	msg.target.dispatchMessage(msg);    //�����msg.targetָ�ľ��Ƿ���������Ϣ��Handler��������Handler���͵���Ϣ�����ֽ�������dispatchMessage�����������ˡ�
	//�����ﲻͬ����Handler��dispatchMessage()���ڴ���Handlerʱ��ʹ�õ�Looper��Looper.loop()������ִ�еģ������ͳɹ��������߼��л���ָ�����߳���ȥִ���ˡ�
	...
}
```
��Handler��dispatchMessage()���������أ�
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
            handleMessage(msg);    //�����ջ��ǵ���handlerMessage()��������յ�����Ϣ��������������ô���Handlerʱ�ɳ���Ա�Լ���д��
        }
    }
```



����Activity��
```java
private Handler handler = new Handler();
```
ʱ��

```java
public Handler(){
    ...
	mLooper = Looper.myLooper();    //ȡ����ActivityThread���main()��prepare(false)֮��洢��sThreadLocal�е�mLooper����Ȼ��ֵ��Handler�����mLooper�������õ������̹߳�����Looper����
	mQueue = mLooper.mQueue;    //��mLooper�е�mQueue(MessageQueue)����ֵ��Handler�����mQueue��֮��Handler�Ϳ��԰ѷ��͵���Ϣ�洢�����MessageQueue֮��
	mCallback = null;
}
```

��Activity�е���handler�����
`handler.sendMessage(...)`;
���յ��õ��ǣ�
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
        msg.target = this;    //Ҳ����˵�������Ϣ�Ƿ��͸�Handler��������Լ��ģ�����
        if (mAsynchronous) {
            msg.setAsynchronous(true);
        }
        return queue.enqueueMessage(msg, uptimeMillis);    //���þ�������Ϣ�����в���һ����Ϣ(������Ĳ������)
    }
```