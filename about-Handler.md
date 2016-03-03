哈哈，今天终于搞明白了，原来Handler的作用方式是那样的

```java
public final boolean sendMessage(Message msg)
```

pushed a message onto the end of the message queue after all pending messages before the current time.
`It will be received in handleMessage(Message) in the thread attached to this handler`.</br>
即那个handler是属于哪个线程的，那么sendMessage()和handleMessage()就应该在哪个线程里。

比如在![android-wifi-connector1](https://github.com/caiqiqi/android-wifi-connecter1)这个项目里的**WifiScanActivity**(主Activity)
```java
private void startNewThread() {
		// 加一个新线程用于与服务器通信
		mRun_ClientThread = new ClientThread(mHandler);
		// 在主线程中启动ClientThread线程用来 a与服务器通信
		mThd_ClientThread = new Thread(mRun_ClientThread);
		mThd_ClientThread.start();
	}
```
将主线程的*mHandler*对象传到*ClientThread*里面，然后在*ClientThread*里面操作 *mHandler*，在*ClientThread*里面又新建一个线程，但是只要是引用那个*mHandler*，调用它的*sendMessage()*方法就行</br>

```java
new Thread() {

				@Override
				public void run() {
					Log.d(TAG, "子线程开启");
					String content;
					// 不断读取Socket输入流中的内容

					try {
						while ((content = br.readLine()) != null) {
							Log.d(TAG, "子线程读取到消息");

							Message msg = new Message();
							msg.what = Constants.MESSAGE_RECEIVED_FROM_SERVER;
							msg.obj = content;

							// 因为这个mHandler是主线程的，所以主线程中的mHandler会处理的
							**mHandler.sendMessage(msg)**;
							Log.d(TAG, "子线程的mHandler已发送消息：" + Constants.MESSAGE_RECEIVED_FROM_SERVER);
						}
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}.start();
```
