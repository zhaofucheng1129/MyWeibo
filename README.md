MyWeibo
=======

仿制的新浪微博

![pic1](/pics/pic1.png)   ![pic2](/pics/pic2.png) <br> 
![pic3](/pics/pic3.png)

功能
=======
使用ASI访问微博接口 <br>
简单的换肤功能 <br>
发送文字微博功能 <br>
下拉刷新最新微博 <br>
提示未读微博数量 <br>
发送带地理位置的微博<br>
选择地理位置时查询附近的地点<br>
扫描二维码（此功能需要在真机查看）<br>

开发环境
=======
xcode5.1<br>
没有启用arc

因为 sina开放平台的权限问题  可以去![http://open.weibo.com/apps](http://open.weibo.com/apps)创建一个 自己的应用 然后将项目中的 
#define kAppKey         @"4119862942"<br>
#define kAppSecret      @"b0c0dd997c99c04f8df4ec37a4846c96"<br>
#define kRedirectURI    @"https://api.weibo.com/oauth2/default.html"<br>
