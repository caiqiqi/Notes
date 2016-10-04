## error: variable ‘throu’ set but not used [-Werror=unused-but-set-variable] 
## cc1plus: all warnings being treated as errors

先看一段代码，我开始没有初始化`throu`，然后给我报这个错，我以为是因为我没有初始化的原因，然后我初始化其为0.0，结果还是碰到这个。然后我突然看到if，哦，也许是if的条件没有满足，导致没有进入if，于是也就没有使用到`throu`这个变量了。然后，我查了一下`enableFlowMonitor`，发现它果然是false，于是将其设置为true即可
```cpp
	Ptr<FlowMonitor> flowMon;
	FlowMonitorHelper flowMonHelper;
	double throu = 0.0 ;    // 在C++11里面，不能只定义一个变量，而不使用
	if (enableFlowMonitor)
	{
		flowMon = flowMonHelper.InstallAll();
		// 调用吞吐量监控
		throu = ThroughputMonitor(&flowMonHelper, flowMon);
	}
```
