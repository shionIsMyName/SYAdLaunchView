//
//  SYAdLaunchViewManager.h
//  SYAdLaunchViewDemo
//  #####################################################################################
//  为了满足您的个性化需求，该库基本上能用的都是暴露的，只要一层一层往下看，应该就可以找到你需要的属性或控件进行个性操作。:)
//  如有问题请加qq:619023485
//  也可以发送邮件到:619023485@qq.com,mingyi_126.com或shionIsMyName@gmail.com.
//  #####################################################################################
//  Created by shiyong on 16/6/30.
//  Copyright © 2016年 sy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dependencies/SYAdLaunchView.h"
@interface SYAdLaunchViewManager : NSObject

/**
 *  广告启动图生产方法
 *
 *  @param cfgHandler     设置回调
 *  @param skipHandler    跳过回调
 *  @param adHandler      广告回调
 *
 *  @return 实例
 */
+(SYAdLaunchView *) launchView:(void(^)(SYAdLaunchView* launchView)) cfgHandler
                   skipHandler:(void(^)(id sender)) skipHandler
                     adHandler:(void(^)(NSMutableArray *boundingParams,
                                        NSInteger index)) adHandler;

/**
 *  新特性视图生产方法
 *
 *  @param images        图片名数组
 *  @param cfgHandler    设置回调
 *  @param expHandler    立即体验回调
 *  @param scrollHandler 滚动回调
 *
 *  @return 实例
 */
+(SYAdLaunchView *) newFeatureViewWithImages:(NSMutableArray *) images
                                  setHandler:(void(^)(SYAdLaunchView* newFeatureView)) cfgHandler
                                  expHandler:(void(^)(id sender)) expBtnHandler
                               scrollHandler:(void(^)(NSInteger totalPage,
                                                      NSInteger currentPage,
                                                      UIButton *expBtn,
                                                      id adLaunchView)) didScrollHandler;


/**
 *  缓存图片,和相关参数到本地
 *
 *  @param imageUrls      图片url数组
 *  @param boundingParams 图片参数数组
 */
+(void) cacheImageUrls:(NSMutableArray *) imageUrls andBoundingParams:(NSMutableArray *) boundingParams;


/**
 *  对比系统版本与缓存版本,判断是否需要显示新特性
 *
 *  @return 是否需要显示新特性
 */
+(BOOL) ifNeedShowNewFeature;

@end
