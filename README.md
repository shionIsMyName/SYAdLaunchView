# 这是什么？
这是一个专门用来实现网络请求广告图作启动图，和版本新特性功能的类库。</br>

# 怎么用？
此库广告启动图的工作流程如下：</br>
1，初始化视图时,会自动去缓存中找图片数据，如果找到就展示，找不到则跳过。(第一次肯定找不到，因为没缓存)</br>
2，请求网络接口获取广告图url以及其业务参数->异步下载缓存起来。(这时候缓存了，那么下次再进app，走流程1就会加载图片和数据了)</br>
### 您可以使用如下代码来实现广告启动图的功能。</br>
    //1.初始化视图
    [SYAdLaunchViewManager launchView:^(SYAdLaunchView *launchView) {
        //您可以对launView进行一些个性化设置
        //比如说来个倒计时(必须先有名称,才能有倒计时，才能有后缀)
        launchView.title_skip=@"跳过";`
        launchView.secs_skip = 10;`
        launchView.surffix_skip =@"s";
        //调用on来显示
        [launchView on];
    } skipHandler:nil 
      adHandler:nil];
    
    //2.缓存图片极其业务参数
    [SYAdLaunchViewManager cacheImageUrls:urls andBoundingParams:params];
![demo1](https://github.com/shionIsMyName/SYAdLaunchView/blob/master/demo_launch_1.gif "demo1")
![demo2](https://github.com/shionIsMyName/SYAdLaunchView/blob/master/demo_launch_2.gif "demo2") 
    
### 您可以使用如下代码实现版本新特性的功能。</br>
    if ([SYAdLaunchViewManager ifNeedShowNewFeature]) {//判断是否需要显示新特性
       [SYAdLaunchViewManager newFeatureViewWithImages:imageNames 
                                            setHandler:^(SYAdLaunchView *newFeatureView) {
                                            [newFeatureView on];
                                            } expHandler:nil 
                                            scrollHandler:nil];
    }
![demo3](https://github.com/shionIsMyName/SYAdLaunchView/blob/master/demo_launch_3.gif "demo3") 

 
### 注
1,该库每次缓存前都会自动对比前后二者，以新传入的url为准,对应的旧的会被删除。所以不用担心使用久了缓存会多。</br>
2,当然，如果产品感觉这样数据更新速度不够实时，你也可以放倒程序代理里，比如说在程序进入后台时缓存，进入前台时在使用视图。或者...</br>
3,强烈建议使用前看demo！！！强烈建议看使用前看demo！！！强烈建议看使用前看demo！！！


# What is this?
This is a library which can help you to achieve a function like getting ads from server and running like a launchImage,besides this can also help you to achieve a new-feature function.

# how to use?
download the demo,and have a try.
