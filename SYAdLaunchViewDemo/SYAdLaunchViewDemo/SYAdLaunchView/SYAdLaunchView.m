//
//  SYAdLaunchView.m
//  SYAdLaunchViewDemo
//  #####################################################################################
//  为了满足您的个性化需求，该库属性基本上都是暴露的，只要一层一层往下看，应该就可以找到你需要的属性进行修改。:)
//  如有问题请加qq:619023485
//  也可以发送邮件到619023485@qq.com,mingyi_126.com或shionIsMyName@gmail.com.
//  #####################################################################################
//  Created by shiyong on 16/6/30.
//  Copyright © 2016年 sy. All rights reserved.
//

#import "SYAdLaunchView.h"
#import "NSObject+SandboxOps.h"




@interface SYAdLaunchView ()<SDCycleScrollViewDelegate>





@end
@implementation SYAdLaunchView
//单例
+(instancetype) sharedView{
    static SYAdLaunchView *sharedView = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedView = [[self alloc] init];
    });
    return sharedView;
}


//初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame =CGRectMake(screenX, screenY, screenW, screenH);
        self.backgroundColor=[UIColor whiteColor];
        self.autoOff=YES;
        _adView=self.adView;
        _logoView=self.logoView;
        _skipBtn=self.skipBtn;
    }
    return self;
}


//显示
-(void) on{
    if (self.adView) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
}


//关闭
-(void) off{
    
    if (_offAnimeType==DISAPPEAR) {//消失
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha=0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else{//滑动
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(-screenW, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}


//广告图
-(SDCycleScrollView *) adView{
    if (!_adView) {
        _adView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(screenX, screenY, screenW, screenH)];
        _adView.mainView.bounces=NO;
        _adView.backgroundColor=[UIColor clearColor];
        _adView.delegate=self;
        if (self.names_cache.count<2) {
            _adView.showPageControl=NO;
            
        }
        _adView.autoScroll=NO;
        _adView.infiniteLoop=NO;
        [self addSubview:_adView];
    }
    return _adView;
}


//跳过按钮
-(UIButton *) skipBtn{
    if (!_skipBtn) {
        _skipBtn = [[UIButton alloc] initWithFrame:CGRectMake(skipBtnX, skipBtnY, skipBtnW, skipBtnH)];
        _skipBtn.hidden=YES;
        [_skipBtn setTitle:@" 跳过 " forState:UIControlStateNormal];
        [_skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _skipBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        _skipBtn.layer.cornerRadius=4;
        _skipBtn.backgroundColor = [UIColor colorWithRed:38/255 green:38/255 blue:38/255 alpha:0.6];
        [_skipBtn addTarget:self action:@selector(skip:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_skipBtn];
    }
    return _skipBtn;
}


//logo图
-(UIImageView *) logoView{
    if (!_logoView) {
        _logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, screenH-_height_logo, screenW, _height_logo)];
        [_logoView setContentMode:UIViewContentModeScaleToFill];
        [self addSubview:_logoView];
        
        //更新其他控件的frame
        [self updatingFrameOfOthers];
    }
    return _logoView;
    
}



//更新其他控件的frame
-(void) updatingFrameOfOthers{
    //更新广告图高度
    CGRect adViewRect = _adView.frame;
    _adView.frame = CGRectMake(adViewRect.origin.x, adViewRect.origin.y, adViewRect.size.width, screenH-_height_logo);
}


//设置logo图片名
-(void) setImgName_logo:(NSString *)imgName_logo{
    _imgName_logo=imgName_logo;
    [_logoView setImage:[UIImage imageNamed:imgName_logo]];
}

//设置新特性用的图片数组
-(void) setImages_nf:(NSMutableArray *)images_nf{
    if (images_nf) {
        NSMutableArray *images = [NSMutableArray array];
        for (NSString* imageName in images_nf) {
            UIImage *img = [UIImage imageNamed:imageName];
            if (img) {
                [images addObject:img];
            }
        }
        _images_nf = images;
        _adView.localizationImagesGroup=_images_nf;
        if (_images_nf.count>1) {
            _adView.showPageControl=YES;
        }
    }
}


//设置图片路径数组
-(void) setNames_cache:(NSMutableArray *)names_cache{
    NSMutableArray *imageArr_cached = [NSMutableArray array];
    //补充路径
    for (NSString* name in names_cache) {
        NSString *cacheDir = [NSObject cacheDir];
        NSString *fullPath= [cacheDir stringByAppendingPathComponent:name];
        BOOL isDir = NO;
        if([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir]){
            UIImage *image = [UIImage imageWithContentsOfFile:fullPath];
            if (image) {
                [imageArr_cached addObject:image];
            }
        }
    }
    
    _names_cache=imageArr_cached;
    _adView.localizationImagesGroup=_names_cache;
    if (_names_cache.count>1) {
        _adView.showPageControl=YES;
    }
}


//倒计时后缀
-(NSString *) surffix_skip{
    return _surffix_skip?_surffix_skip:@"";
}


//设置倒计时
-(void) setSecs_skip:(int)secs_skip{
    if (!_skipBtn.hidden) {
        _secs_skip=secs_skip;
        [self letsCountDown:secs_skip];
    }
}


//设置略过按钮标题
-(void) setTitle_skip:(NSString *)title_skip{
    _title_skip = title_skip;
    
    title_skip = [NSString stringWithFormat:@" %@ ",title_skip];
    [_skipBtn setTitle:title_skip forState:UIControlStateNormal];
    if (_skipBtn.hidden) {
        _skipBtn.hidden=NO;
    }
}


//设置logo高度
-(void) setHeight_logo:(CGFloat)height_logo{
    _height_logo=height_logo;
    
    CGRect logoRect = self.logoView.frame;
    self.logoView.frame = CGRectMake(logoRect.origin.x, screenH-_height_logo,logoRect.size.width, _height_logo);
    //更新其他控件的frame
    [self updatingFrameOfOthers];
    
}

//轮播控件滚动时间
-(void) setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    _adView.autoScrollTimeInterval=_autoScrollTimeInterval;
}

//轮播控件是否无限循环
-(void) setInfiniteLoop:(BOOL)infiniteLoop{
    _infiniteLoop = infiniteLoop;
    _adView.infiniteLoop=_infiniteLoop;
}

//轮播控件是否自动滚动
-(void) setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    _adView.autoScroll = autoScroll;
}

//是否显示分页控件
-(void) setShowPageControl:(BOOL)showPageControl{
    _showPageControl = showPageControl;
    _adView.showPageControl = _showPageControl;
}

//分页控件样式
-(void) setPageControlStyle:(SDCycleScrollViewPageContolStyle)pageControlStyle{
    _pageControlStyle=pageControlStyle;
    _adView.showPageControl =_pageControlStyle;
}

//分页控件位置
-(void) setPageControlAliment:(SDCycleScrollViewPageContolAliment)pageControlAliment{
    _pageControlAliment = pageControlAliment;
    _adView.showPageControl = _pageControlAliment;
}

//分页控件图标大小
-(void) setPageControlDotSize:(CGSize)pageControlDotSize{
    _pageControlDotSize = pageControlDotSize;
    _adView.pageControlDotSize = _pageControlDotSize;
}

//分页控件颜色
-(void) setDotColor:(UIColor *)dotColor{
    _dotColor = dotColor;
    _adView.dotColor = _dotColor;
}


//开始倒计时
-(void) letsCountDown:(int)secs_skip{
    __block int timeout = secs_skip+1; //倒计时时间 + 1
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 1){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.autoOff) {
                    [self off];
                }
            });
        }else{
            //每次倒计时
            dispatch_async(dispatch_get_main_queue(), ^{
                if (timeout==1) {
                    [_skipBtn setTitle:[NSString stringWithFormat:@" %@ ",_title_skip] forState:UIControlStateNormal];
                }else{
                    [_skipBtn setTitle:[NSString stringWithFormat:@" %@%d%@ ",_title_skip,timeout,self.surffix_skip] forState:UIControlStateNormal];
                }
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}


//省略
-(void) skip:(id) sender{
    if (self.autoOff) {
        [self off];
    }
    if (_skipHandler) {
        self.skipHandler(sender);
    }
}


//点击滚轴视图
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (_adHandler) {
        [self off];
        self.adHandler(self.params_cache,index);
    }
}


//翻滚
- (void) totalPage:(NSInteger) totalPage andCurrentPage:(NSInteger) currentPage{
    if (_didScrollHandler) {
        self.didScrollHandler(totalPage,currentPage,self.skipBtn,self);
    }
}

@end
