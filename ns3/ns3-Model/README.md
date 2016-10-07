# ns3--WIFI传输中的常见模型

原文: http://blog.csdn.net/barcodegun/article/details/6955035

## ErrorRateModel (误码模型)
The interface for Wifi's error models 
### 

## PropagationDelayModel (传播延时模型)
Calculate a propagation delay.
计算传播的延时 
### ConstantSpeedPropagationDelayModel (恒定速度传播延时)
The propagation delay speed is constant
### RandomPropagationDelayModel (随机传播延时)
The propagation delay is random 

## PropagationLossModel (传播损耗模型)
Modelize the propagation loss through a transmission medium.
Calculate the receive power (dbm) from a transmit power (dbm) and a mobility model for the source and destination positions.
为信号在传输介质中的传播损耗建立模型。
通过发送功率(dbm)和源和目的位置移动模型计算出接收功率(dbm)。

### FixedRssLossModel (恒定接收信号强度的损耗模型)
Return a constant received power level independent of the transmit power
不管发送功率是多少，都返回一个恒定的接收功率

### LogDistancePropagationLossModel #
A log(in math) distance propagation model

### ThreeLogDistancePropagationLossModel
A log distance path loss propagation model with three distance fields. This model is the same as 
ns3::LogDistancePropagationLossModel except that it has three distance fields: 
near, middle and far with different exponents. 


### MatrixPropagationLossModel
The propagation loss is fixed for each pair of nodes and doesn't depend on their actual positions.

### NakagamiPropagationLossModel   (seems rare to me)
Nakagami-m fast fading propagation loss model.

### RandomPropagationLossModel #
The propagation loss follows a random distribution.

### RangePropagationLossModel  #
The propagation loss depends only on the distance (range) between transmitter and receiver.
The single MaxRange attribute (units of meters) determines path loss. 
- Receivers `at or within` MaxRange meters receive the transmission at the transmit power level. 
- Receivers `beyond` MaxRange receive at power -1000 dBm (effectively zero). 

### TwoRayGroundPropagationLossModel  (dont know what it is)
A Two-Ray Ground propagation loss model ported from NS2 Two-ray ground reflection model.



