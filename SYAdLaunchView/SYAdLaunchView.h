//
//  SYAdLaunchView.h
//  SYAdLaunchViewDemo
//  #####################################################################################
//  为了满足您的个性化需求，该库属性基本上都是暴露的，只要一层一层往下看，应该就可以找到你需要的属性进行修改。:)
//  如有问题请加qq:619023485
//  也可以发送邮件到619023485@qq.com,mingyi_126.com或shionIsMyName@gmail.com.
//  #####################################################################################
//  Created by shiyong on 16/6/30.
//  Copyright © 2016年 sy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"


#define screenX [UIScreen mainScreen].bounds.origin.x
#define screenY [UIScreen mainScreen].bounds.origin.y
#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height



#define skipBtnW 60
#define skipBtnH 30
#define skipBtnX screenW-skipBtnW-30
#define skipBtnY 30




/**
 *关闭动画类型 默认消失
 *
 */
typedef enum : NSUInteger {
    DISAPPEAR,//消失
    SLIDE,//滑动
} OFFTYPE;

typedef void(^SkipBtnHandler)(id sender);
typedef void(^AdImageHandler)(NSMutableArray *boundingParams,NSInteger index);

//参数依次是,总页数,当前页数,立即体验按钮,和视图实例
typedef void(^DidScrollHandler)(NSInteger totalPage,NSInteger currentPage,UIButton *expBtn,id adLaunchView);
@interface SYAdLaunchView : UIView

/**跳过按钮回调*/
@property (nonatomic,copy) SkipBtnHandler skipHandler;
/**广告图回调*/
@property (nonatomic,copy) AdImageHandler adHandler;
/**滚动页面回调*/
@property (nonatomic,copy) DidScrollHandler didScrollHandler;

/**跳过按钮*/
@property (nonatomic,retain) UIButton *skipBtn;
/**跳过倒计时*/
@property(nonatomic,assign) int secs_skip;
/**倒计时后缀 例如：秒,s*/
@property (nonatomic,copy) NSString *surffix_skip;
/**跳过按钮标题*/
@property (nonatomic,copy) NSString *title_skip;


/**logo*/
@property (nonatomic,retain) UIImageView *logoView;
/**logo高*/
@property(nonatomic,assign) CGFloat height_logo;
/**logo图名*/
@property (nonatomic,retain) NSString *imgName_logo;


/**轮播控件*/
@property (nonatomic,retain) SDCycleScrollView *adView;
/**轮播控件是否无限循环,默认NO*/
@property(nonatomic,assign) BOOL infiniteLoop;
/**轮播控件自动滚动间隔时间,默认2s*/
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;
/**是否自动滚动,默认NO*/
@property(nonatomic,assign) BOOL autoScroll;
/** 是否显示分页控件,默认一条隐藏，多条显示*/
@property (nonatomic, assign) BOOL showPageControl;
/** pagecontrol 样式，默认为动画样式*/
@property (nonatomic, assign) SDCycleScrollViewPageContolStyle pageControlStyle;
/**分页控件位置*/
@property (nonatomic, assign) SDCycleScrollViewPageContolAliment pageControlAliment;
/**分页控件小圆标大小*/
@property (nonatomic, assign) CGSize pageControlDotSize;
/**分页控件小圆标颜色*/
@property (nonatomic, strong) UIColor *dotColor;




/**图片名数组 如:[@"cat1.jpg",@"cat2.jpg",@"cat3.jpg"]*/
@property (nonatomic,retain) NSMutableArray *names_cache;
/**图片关联参数 如图片关联的跳转id:[@"201212123301",@"2012123302",@"201212123303"]*/
@property (nonatomic,retain) NSMutableArray *params_cache;
/**图片名-新特性功能用*/
@property (nonatomic,retain) NSMutableArray *images_nf;



/**点击跳过和倒计时结束时是否自动关闭 默认值为YES*/
@property(nonatomic,assign) BOOL autoOff;

/**关闭视图动画类型 默认为消失*/
@property(nonatomic,assign) OFFTYPE offAnimeType;


/**单例访问*/
+(instancetype) sharedView;

/**显示*/
-(void) on;

/**关闭*/
-(void) off;



@end
