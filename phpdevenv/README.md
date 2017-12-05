# PHPDevEnv

## 基于Docker的本地PHP开发环境

1. [项目开源地址](http://git.oschina.net/mustanggu/phpdevenv)

2. 环境目录结构

    ```
    .
    ├── LICENSE
    ├── README.md                           // 说明文档
    ├── config
    │   ├── composer                        // composer 可执行文件
    │   ├── crontab
    │   │   └── root                        // crontab 计划任务配置
    │   ├── nginx
    │   │   ├── conf.d                      // 站点配置目录
    │   │   ├── listen443.cnf               // https 443端口监听配置
    │   │   └── 其他nginx配置文件...略
    │   ├── php
    │   │   ├── php                         // php 相关配置目录
    │   │   ├── php-fpm.conf                // php-fpm 基础配置文件
    │   │   └── php-fpm.d                   // php-fpm 扩展配置目录
    │   └── supervisor
    │       └── conf.d                      // supervisor 扩展配置目录
    ├── docker-compose.yml                  // docker容器启动配置
    ├── logs                                // 运行日志输出目录
    └── www                                 // 站点代码目录
        └── phpinfo.localhost.com           // 示例phpinfo站点目录
            └── index.php
    ```
    
3. 环境基本说明

  * 已安软件装服务
  
      |     |名称       |版本   | 
      |:---:|:--------:|:-----:|
      |1    |nginx     |1.12.0 |
      |2    |php       |7.1.6  |
      |3    |supervisor|3.2.0  |
      |4    |crond     |4.5    |
        
      PHP编译参数:
        
      > './configure' '--build=x86_64-linux-musl' '--with-config-file-path=/usr/local/etc/php' '--with-config-file-scan-dir=/usr/local/etc/php/conf.d' '--disable-cgi' '--enable-ftp' '--enable-mbstring' '--enable-mysqlnd' '--with-curl' '--with-libedit' '--with-openssl' '--with-zlib' '--with-pcre-regex=/usr' '--enable-fpm' '--with-fpm-user=www-data' '--with-fpm-group=www-data' 'build_alias=x86_64-linux-musl'
        
    * 其他已安装内容

      * 已安装PHP模块列表(php -m 命令查看,未标注版本号的组件位php内置组件,编译安装时使用相关的enable编译参数加入,同php一同编译安装):
            
        |Module     |Version| 
        |:--------: |:-----:|
        |bcmath     |       |
        |Core       |7.1.6  |
        |ctype      |       |
        |curl       |       |
        |date       |       |
        |dom        |       |
        |exif       |1.4    |
        |fileinfo   |1.0.5  |
        |filter     |       |
        |ftp        |       |
        |gd         |2.6.3  |
        |hash       |       |
        |iconv      |       |
        |json       |1.5.0  |
        |libxml     |2.9.4  |
        |mbstring   |1.3.2  |
        |mcrypt     |2.5.8  |
        |mongodb    |1.2.9  |
        |mysqli     |       |
        |mysqlnd    |       |
        |openssl    |       |
        |pcre       |8.38   |
        |PDO        |       |
        |pdo_mysql  |       |
        |pdo_sqlite |3.15.1 |
        |Phar       |       |
        |posix      |       |
        |readline   |       |
        |redis      |3.1.2  |
        |Reflection |       |
        |session    |       |
        |shmop      |       |
        |SimpleXML  |       |
        |soap       |       |
        |sockets    |       |
        |SPL        |       |
        |sqlite3    |       |
        |standard   |       |
        |sysvsem    |       |
        |tokenizer  |       |
        |xml        |2.9.4  |
        |xmlreader  |       |
        |xmlrpc     |7.1.6  |
        |xmlwriter  |       |
        |zip        |1.13.5 |
        |zlib       |1.2.11 |
        |opcache    |       |
            
    * 如果有需要另外安装其他扩展的,可以参考[DockerHub](https://hub.docker.com/_/php/)上的php镜像的官方页面在"How to install more PHP extensions"章节有详细讲解如何安装模块扩展.

4. 常见问题

  * 如何启动本地开发环境

    启动phpinfo站点检查环境运行情况:
    
    > 在终端进入当文档所在的目录
    
    >  执行命令
    
    > \# docker-compose up -d
    
    > 配置hosts 127.0.0.1 phpinfo.localhost.com
    
    > 打开浏览器访问http://phpinfo.localhost.com
    
    可以看到phpinfo输出的环境信息.
    
    ***
    
    启动本地站点:

    > 进入本说明文件所在目录
    
    > 1.在www目录下新建站点目录或在www目录下添加站点目录的软连接.
    
    > 2.添加站点的nginx配置文件到config/nginx/conf.d目录,格式可以参考已存在的phpinfo.localhost.com.conf文件
    
    > 3.cd回本docker-compose.yml文件所在目录
    
    > 4.执行命令
    
    > \# docker-compose up -d
    
    > 或使用-f参数指定yml文件
    
    > \# docker-compose -f [docmer-compose.yml路径] up -d
    
    > 配置自己站点的hosts,访问站点
    
    > **注意**:如果本地多个站点之间需要互相进行http通信,则需要在docker-compose.yml文件末尾的extra_hosts中添加所有站点的hosts配置.
        
        
  * docker容器启动后我要如何启动里面的nginx和php?
        
    > 不需要手动进入容器启动nginx和php
    
    > 本镜像在制作时已经考虑到该问题,容器启动后,会自动启动supervisor进程管理器
    
    > 管理器的默认配置会启动nginx和php-fpm进程会自动启动
    
    > 如果发现nginx并未正常启动,请仔细检查挂载进去的nginx站点配置文件
    
    > 修改正确后进入supervisor,restart其中的nginx进程即可
    

  * 我使用常规的进入容器命令"docker exec -it xxx /bin/bash"报错,无法进入容器,是何原因?

    > 本容器镜像基于alpine-linux系统制作,没有bash所以进入容器的命令如下:
    
    > \# docker exec -it xxx /bin/sh 
    
    > xxx为 容器id/容器名称
        
  * 我想自己构建一个类似的镜像,要如何操作?

    > 本镜像的制作用Dockerfile均在GitHub上
    
    > 地址:[my-images](https://github.com/mustang1988/my-images)
    
    > 欢迎交流
        
  * 我想添加一个守护进程,比如队列消费需要怎么做?

    以laravel的队列消费为例,假设已开发完成相关的队列消费Job,队列监听启动脚本为:
    
    > php artisan queue:listen --queue=queue001
    
    在config/supervisor目录中添加supervisor的扩展配置,queue001.ini,内容如下:
    
    ```
        ; 自定义进程名称
        [program:queue001]
        ; 需要执行的命令
        command                 = php artisan queue:listen --queue=queue001
        process_name            = %(program_name)s
        ; 命令执行的目录
        directory               = /data/www/xxx("laravel项目的站点目录")
        numprocs                = 1
        ; supervisord启动时自动启动
        autostart               = true
        ; 进程退出后自动重启
        autorestart             = true
        ; 控制台输出日志
        stdout_logfile          = /logs/supervisor_queue001_sout.log
        ; 异常输出日志
        stderr_logfile          = /logs/supervisor_queue001_error.log    
    ```
    
    配置文件添加完成后进入supervisor
    
    > \# supervisorctl
    
    > \> reload
    
    待reload完成后
    
    > \> status 
    
    可以查看当前队列消费进程的状态,状态为RUNNING说明队列消费进程正常启动并运行中,此时supervisor会维持该进程的运行,任何非正常退出该进程或kill该进程,supervisor都会自动重启进程.

    > ps:docker-php-ext-opcache.ini 缓存配置文件
