# iWshop<微信开源商城>

iWshop是一个开源的微信商城。为了保证轻量级，使用了作者自主开发的mvc框架。 

LightMvc现已分离 <a href="https://git.oschina.net/koodo/LightMvc">https://git.oschina.net/koodo/LightMvc</a> 

>iWshop 交流群：`470442221`

>iWshop 交流社区：<a href="http://asw.iwshop.cn/" target="_blank">http://asw.iwshop.cn/</a> 

>iWshop 安装教程：<a href="http://git.oschina.net/koodo/iWshop/blob/dev/html/docs/install.md">http://git.oschina.net/koodo/iWshop/blob/dev/html/docs/install.md</a>


>安装教程图文教程及注意事项(JerryJee提供的教程)：<a target="_blank" href="http://www.jiloc.com/htmls/41.html">http://www.jiloc.com/htmls/41.html</a>

>微信公众平台三方接入技术问题总结,提问前必看(JerryJee提供的教程)：<a target="_blank" href="http://www.jiloc.com/htmls/43.html">http://www.jiloc.com/htmls/43.html</a>

>添加对wordpres的文章整合，可实现微信关键词对wordpress的内容匹配：<a target="_blank" href="http://www.jiloc.com/htmls/46.html">http://www.jiloc.com/htmls/46.html</a>


>`历史版本发布` <a target="_blank" href="http://git.oschina.net/koodo/iWshop/releases">http://git.oschina.net/koodo/iWshop/releases</a>

## 配置说明 （请注意，iWshop当前稳定版正在开发中，请谨慎安装）

#### 一、根目录修改说明

如果是服务器根目录，必须修改为` /`

如果是服务器子目录，必须修改为`/subroot/` 等有左右斜杠的格式

修改文件：config/config.php 中的 $config->docroot选项

#### 二、手动部署说明

- 服务器配置过程略。

- 创建`/install/install.lock`

- 导入`/install/iWshop.sql`

- 后台地址（以域名www.iwshop.cn为例）为：http://www.iwshop.cn/?/Wdmin/login/

- 微信消息接口地址：http://www.iwshop.cn/wechat/ (切莫忘了最后的 / )

#### 三、目录权限说明

执行一下install里的shell文件

    ./install/dirmod.sh

请确保您的php配置中`magic_quotes_gpc为Off`，否则一些功能将失效

#### 四、配置文件config.php说明

初始配置文件为`config_sample.php`, 在/config/目录下

请编辑`config_sample.php`文件并且重命名为`config.php`

#### 五、运行环境要求
 
    * MySQL 5.5.3+ (utf8mb4编码用于保存带有emoji表情的微信用户昵称)**

    * PHP5.4+

    * PHP扩展：php_mysql php_curl php_pdo_mysql php_gd2

#### 相关下载

><a href="http://down.iwshop.cn/iwshop_release/iwshop-beta-0.9.0.zip" target="_blank">iwshop-beta-0.9.0.zip</a> 

><a href="http://down.iwshop.cn/iwshop_release/iwshop-beta-0.9.1.zip" target="_blank">iwshop-beta-0.9.1.zip</a> 

><a href="http://down.iwshop.cn/iwshop_release/iwshop-beta-0.9.2.zip" target="_blank">iwshop-beta-0.9.2.zip</a> 

><a href="http://down.iwshop.cn/iwshop_release/iwshop-beta-0.9.3.zip" target="_blank">iwshop-beta-0.9.3.zip</a> 

><a href="http://down.iwshop.cn/iwshop_release/iwshop-beta-0.9.4.zip" target="_blank">iwshop-beta-0.9.4.zip</a>

# 关于社区版

项目源自iwshop的开源版本 (http://git.oschina.net/koodo/iWshop) ，原项目存在不少bug，社区在使用过程中每个人都有做修改，因此创建此项目，将大家修改集中，成为社区版。

### 修改内容

参见versions.txt

### 社区版安装使用

说明：由于数据库做过修改（@Happy Elf）同时考虑社区小伙伴都是有技术实力的，因此采用直接导出方式，至于install中的正常安装以后再说。 

1. 直接导入install目录下iwshop.sql文件作为数据库，默认后台管理员账号为admin密码为qqqqqq，如果不对请自行到`models/wdmin/WdminAdmin.php`中`pwdCheck`中添加代码
    ```
    die(var_dump($this->encryptPassword($pwd_submit)));
    ```
    获取之后写入数据库admin用户的密码字段中

2. 数据库安装好之后在config目录下将config_sample.php拷贝为config.php，config_database_sample.php拷贝为config_database.php，config_msg_template_sample.php拷贝为config_msg_template.php并编辑对应配置内容。其中涉及到微信公众号的信息及微信商户平台证书等，目前目录下证书为iwshop开源版本自带，请使用自己账号的证书替换掉，消息模板也需要使用自己账号去生成后填进来。

3. 以下目录给予写权限(777)：
    ```
    exports/orders_export
    html/products
    models/json_cache
    models/sql_cache
    tmp
    uploads
    ```

4. 微信公众平台的开发者配置中URL（服务器地址）使用以下格式内容

    ```
    http://www.xxx.com/wechat/
    ```
