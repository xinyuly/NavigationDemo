# NavigationDemo
三种popViewController的效果,例如淘宝、京东的“整体返回”效果

实现思路：

1.创建Pan手势识别器

2.实现手势的相应事件

3.创建截图需要的backgroundView和作为遮罩的blackMask，存放截图所需的数组

4.在push前截图，并保存

5.重写常用的pop方法
