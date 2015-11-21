哈哈，今天终于搞明白了，原来Handler的作用方式是那样的

```java
public final boolean sendMessage(Message msg)
```

pushed a message onto the end of the message queue after all pending messages before the current time.
`It will be received in handleMessage(Message) in the thread attached to this handler`.</br>
即那个handler是属于哪个线程的，那么sendMessage()和handleMessage()就应该在哪个线程里。
