# TextView
在项目开发过程中，对于大文本输入常用TextView来实现，但由于iOS没有实现其高度可变的特性，因此，需要我们手动来实现TextView的frame高度可变。类似与Message中textView文本输入。
<br>其原理主要是通过，UITextView的contentSize来计算亲高度，实现效果如图所示
![image](https://github.com/xuqigang/TextView/raw/master/SimulatorScreenShot.png)

