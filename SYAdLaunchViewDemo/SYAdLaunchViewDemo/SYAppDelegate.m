//
//  SYAppDelegate.m
//  SYAdLaunchViewDemo
//
//  Created by shiyong on 16/7/5.
//  Copyright © 2016年 sy. All rights reserved.
//

#import "SYAppDelegate.h"
#import "SYAdLaunchViewManager.h"

@implementation SYAppDelegate

-(BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    BOOL result = [super application:application didFinishLaunchingWithOptions:launchOptions];
    //详细-单张广告启动图演示
    [self detailTutorial];
    
    //精简-多张广告启动图演示
//    [self simpleTutorial];
    
    //版本新特性演示
//    [self newFeatureTutorial];
    
    return result;
}


-(void) detailTutorial{
    //1.使用SYAdLaunchView
    //(很抱歉,除了makeView这个block可以直接使用self,其他的都是需要弱引用的。)
    // 因为makeView是个栈block执行完就会释放,而其他的block被SYAdLaunchView引用。)
    // 所以在adHandler,skipHandler,didScrollHandler中使用self，别忘了弱引用
    // __weak typeof(self) weakSelf = self;
    [SYAdLaunchViewManager launchView:^(SYAdLaunchView *launchView) {
        //您可以对launView进行一些个性化设置
        //比如说来个倒计时(必须先有名称,才能有倒计时，才能有后缀)
        launchView.title_skip=@"跳过";
        launchView.secs_skip = 10;
        launchView.surffix_skip =@"s";
        
        //比如说来个logo
        launchView.imgName_logo=@"logo.jpg";//logo要是本地assets里的哦
        launchView.height_logo=150;
        
        //设置关闭动画类型
//        launchView.offAnimeType=SLIDE;
        
        //调用on来显示
        [launchView on];

    } skipHandler:^(id sender) {//如果需要在点击跳过按钮之后做一些事，可以实现这个block
        NSLog(@"点击跳过");
    } adHandler:^(NSMutableArray *boundingParams, NSInteger index) {
        //广告点击回调,给您传递了之前您缓存的绑定参数数组，以及您当前点击的索引便于您进行业务操作
        NSString *param = boundingParams[index];
        NSLog(@"param--->%@",param);
    }];
    
    
    //2.缓存图片
    //图片的url,你懂得。一般请求后台的接口给你。
    NSMutableArray *urls=[[NSMutableArray alloc] initWithObjects:@"http://image.tianjimedia.com/uploadImages/2013/064/37FE45SL2309.jpg", nil];
    
    
    //图片对应的参数，比如说你点击这个广告图要跳往一个控制器，这个控制器又需要一个参数来决定具体加载哪些数据
    //(如果您感觉字符串不够用的话，可以传对象，或者字典...)
    NSMutableArray *params = [[NSMutableArray alloc] initWithObjects:@"00001", nil];
    
    
    //缓存图片到沙盒，下次打开应用时,只要你初始化了SYAdLaunchView，它就就会自动去沙盒找。
    //另外如果你的图片url或者参数变化的话,SYAdLaunchManager会自动删除您不需要的图片缓存，保存最新的。
    [SYAdLaunchViewManager cacheImageUrls:urls andBoundingParams:params];
    
    

    
}



-(void) simpleTutorial{
    //没错，区别就是多传了数据
    [SYAdLaunchViewManager launchView:^(SYAdLaunchView *launchView) {
        launchView.title_skip=@"跳过";
        launchView.secs_skip=10;
        launchView.surffix_skip=@"秒";
        [launchView on];
    } skipHandler:^(id sender) {
         NSLog(@"点击跳过");
    } adHandler:^(NSMutableArray *boundingParams, NSInteger index) {
         NSLog(@"params=>%@",boundingParams.description);
         NSLog(@"点击了第%ld",index);
    }];
    
    NSMutableArray *urls = [[NSMutableArray alloc] initWithObjects:@"http://img5.pcpop.com/bizhi/big/10/174/523/10174523.jpg",@"http://img4q.duitang.com/uploads/item/201503/06/20150306183830_rvrE8.thumb.700_0.png",@"http://img6.guang.j.cn/thumb/g1/M01/A2/32/wKggKVbgWZTAYaDQAAF-Cp7XIl444.jpeg_720x1280x50.jpeg", nil];
    NSMutableArray *params = [[NSMutableArray alloc] initWithObjects:@"00001",@"00002",@"00003", nil];
    
    [SYAdLaunchViewManager cacheImageUrls:urls andBoundingParams:params];
    
}



-(void) newFeatureTutorial{
    //精简-新版本特性
    //这一块的测试需要手动改info.plist的 bundle version，勿忘。
    NSMutableArray *imageNames = [[NSMutableArray alloc] initWithObjects:@"cat1.jpg",@"cat3.jpg",@"cat4.jpg",nil];
    
// if ([SYAdLaunchViewManager ifNeedShowNewFeature]) {//判断是否需要显示新特性
    [SYAdLaunchViewManager newFeatureViewWithImages:imageNames setHandler:^(SYAdLaunchView *newFeatureView) {
        [newFeatureView on];
    } expHandler:^(id sender) {
        NSLog(@"您点击了立即体验");
    } scrollHandler:^(NSInteger totalPage, NSInteger currentPage, UIButton *expBtn, id adLaunchView) {
        //滚动到最后的时候显示 立即体验
        if (currentPage+1==totalPage) {
            expBtn.hidden=NO;
        }else{
            expBtn.hidden=YES;
        }
    }];
//}

    
}

@end
