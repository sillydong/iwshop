#iWshop完整安装指南#

> 本文档仅介绍如何安装iWshop并且完成微信公众号对接，其他微信认证、微信支付等申请可以参考：
> 百度经验 [微信认证申请](http://jingyan.baidu.com/article/39810a23eaad8ab636fda69b.html "微信认证申请")、[微信支付申请](http://jingyan.baidu.com/article/3a2f7c2e76314a26afd6119b.html "微信支付申请")

>iWshop 交流群：<b>470442221</b>

>iWshop 类文档：<a href="http://docs.ycchen.cc/iwshop/index.html" target="_blank">http://docs.ycchen.cc/iwshop/index.html</a> 


###一、准备工作###

####服务器环境要求####

- PHP5.3+
- MySQL 5.5.3+ (utf8mb4编码用于保存带有emoji表情的微信用户昵称)
- PHP扩展：php\_mysql php\_curl php\_pdo\_mysql php\_mcrypt php\_gd2
- 请确保您的php.ini配置中magic\_quotes\_gpc为Off，否则某些功能可能无法使用
- 如果需要redis，请加载php_redis扩展
- iWshop是以UrlQuery的形式组合参数的，所以不需要伪静态模块。

####开始安装iWshop####
<a href="http://git.oschina.net/koodo/iWshop/releases" target="_blank">http://git.oschina.net/koodo/iWshop/releases</a>

现在以安装目录<b>F:\dev_project\test\_iwshop</b>为例进行安装，我的httpd-vhosts.conf其中的一个设置是这样的。关于如何使用apache的vhosts可以参考：<a href="http://httpd.apache.org/docs/2.0/vhosts/examples.html" target="_blank">Apache官方示例</a> 

	<VirtualHost *:80>
	    DocumentRoot "F:\dev_project\test_iwshop"
	    ServerName test.iw.com
	    <Directory "F:\dev_project\test_iwshop">
	        AllowOverride All
	        Options FollowSymLinks
	        Order allow,deny
	        Allow from all
	    </Directory>
	</VirtualHost>

当然你也可以直接放服务器根目录。

![](http://download-iwshop.oss-cn-shenzhen.aliyuncs.com/iwshop_release%2Fimages%2Finstall_1.png?b=1)

然后在浏览器中打开localhost，或者vhosts指向的域名。

![](http://download-iwshop.oss-cn-shenzhen.aliyuncs.com/iwshop_release%2Fimages%2Finstall_2.png)

填写微店名称（可以在后台修改），数据库密码，后台管理员账号密码（可以在后台修改），然后点击下一步。

![](http://download-iwshop.oss-cn-shenzhen.aliyuncs.com/iwshop_release%2Fimages%2Finstall_3.png)

>这里特别说明一下系统根目录，如果是在DocumentRoot的根目录下安装，那么就是<b>"/"</b>，如果是在某个子目录比如/iw/，那么这里就要填写<b>"/iw/"</b>，一般情况下都会自动获取，无需填写，如果遇到css或者js等静态文件无法加载页面错乱的问题，请检查config.php里面的docroot选项。

点击马上安装，如果数据库版本和php环境没有什么配置问题的话，就安装成功了。

![](http://download-iwshop.oss-cn-shenzhen.aliyuncs.com/iwshop_release%2Fimages%2Finstall_4.png)

- 假设服务器域名是：www.iwshop.cn，那么你的：
- 后台地址：http://www.iwshop.cn/?/Wdmin/login/
- 微信消息接口地址：http://www.iwshop.cn/wechat/

### 二、微信对接###

// todo

###三、bug反馈###

[http://git.oschina.net/koodo/iWshop/issues](http://git.oschina.net/koodo/iWshop/issues)

iWshop 交流群：470442221

作者邮箱 koodo@qq.com