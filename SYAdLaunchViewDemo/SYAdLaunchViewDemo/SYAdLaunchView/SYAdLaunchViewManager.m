//
//  SYAdLaunchViewManager.m
//  SYAdLaunchViewDemo
//  #####################################################################################
//  为了满足您的个性化需求，该库属性基本上都是暴露的，只要一层一层往下看，应该就可以找到你需要的属性进行修改。:)
//  如有问题请加qq:619023485
//  也可以发送邮件到619023485@qq.com,mingyi_126.com或shionIsMyName@gmail.com.
//  #####################################################################################
//  Created by shiyong on 16/6/30.
//  Copyright © 2016年 sy. All rights reserved.
//




#define key_names @"ImagePathArr"
#define key_params @"BoundingParams"



#define fileManager [NSFileManager defaultManager]
#define userDef [NSUserDefaults standardUserDefaults]
#define key_version (NSString *)kCFBundleVersionKey
#import "SYAdLaunchViewManager.h"
#import "NSObject+SandboxOps.h"
#import "NSMutableArray+ForComparing.h"



@implementation SYAdLaunchViewManager


/**工厂方法*/
+(SYAdLaunchView *) launchView:(void(^)(SYAdLaunchView* launchView)) cfgHandler
                   skipHandler:(void(^)(id sender)) skipHandler
                     adHandler:(void(^)(NSMutableArray *boundingParams
                                       ,NSInteger index)) adHandler{
    //判断是否缓存图片数据
    NSMutableArray *names_cache = [[userDef arrayForKey:key_names] mutableCopy];
    NSMutableArray *params_cache = [[userDef arrayForKey:key_params] mutableCopy];
    
    if (names_cache&&names_cache.count>0) {
        SYAdLaunchView *launchView = [SYAdLaunchView sharedView];
        launchView.adHandler=adHandler;
        launchView.skipHandler=skipHandler;
        launchView.names_cache = names_cache;
        launchView.params_cache= params_cache;

        cfgHandler(launchView);
        
        return launchView;
    }
    return nil;
}


//新特性视图
+(SYAdLaunchView *) newFeatureViewWithImages:(NSMutableArray *) images
                            setHandler:(void(^)(SYAdLaunchView* newFeatureView)) cfgHandler
                        expHandler:(void(^)(id sender)) expBtnHandler
                     scrollHandler:(void(^)(NSInteger totalPage,
                                            NSInteger currentPage,
                                            UIButton *expBtn,
                                            id adLaunchView)) didScrollHandler{
    if (images&&images.count>0) {
        SYAdLaunchView *launchView = [SYAdLaunchView sharedView];
        launchView.skipHandler=expBtnHandler;
        launchView.didScrollHandler=didScrollHandler;
        launchView.images_nf = images;
        
        launchView.skipBtn.center = launchView.center;
        launchView.title_skip=@" 立即体验 ";
        [launchView.skipBtn sizeToFit];
        launchView.offAnimeType=SLIDE;
        launchView.skipBtn.hidden=YES;
        cfgHandler(launchView);
        return launchView;
    }
    return nil;
}


/**对比系统版本与本地缓存版本*/
+(BOOL) ifNeedShowNewFeature{

    //取出缓存版本号与系统版本号(第一次运行,缓存版本号为null)
    NSString *version_cache = [userDef valueForKey:key_version];
    NSString *version_sys = [[[NSBundle mainBundle] infoDictionary] valueForKey:key_version];
    
    if ([version_cache isEqualToString:version_sys]) {
        return NO;
    }else{
    //更新缓存版本号为最新，这样下次启动就会系统版本号一致
        [userDef setValue:version_sys forKey:key_version];
        return YES;
    }
}


/**缓存图片*/
+(void) cacheImageUrls:(NSMutableArray *) imageUrls
     andBoundingParams:(NSMutableArray *) boundingParams{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    
        //判断需要更新的图片名
        NSMutableArray *names_cache = [userDef valueForKey:key_names];
        if(names_cache&&names_cache.count>0){
            //如果缓存了图片路径，将传入的图片名和缓存的图片名进行对比
            BOOL isEqual = [NSMutableArray isThisEqual:names_cache to:imageUrls];
            
            if (isEqual) {//一致,说明不需要更新
                [userDef setObject:boundingParams forKey:key_params];
                return ;
            }else{//不一致,先对比,后更新
                NSMutableArray *newImgNames = [self compareAndUpdateWithCached:names_cache andNew:imageUrls];
                //更新相关索引用参数
                [userDef setObject:newImgNames forKey:key_names];
                [userDef setObject:boundingParams forKey:key_params];
            }
            [userDef synchronize];
        }else{
            //整体下载更新图片和参数
            [self downDataWithUrls:imageUrls boundingParams:boundingParams];
        }
    });
}

/**比较后更新沙盒缓存文件和相关参数*/
+(NSMutableArray *) compareAndUpdateWithCached:(NSMutableArray *)caches andNew:(NSMutableArray*) newData{
    //清空相关索引用参数
    [userDef removeObjectForKey:key_names];
    [userDef removeObjectForKey:key_params];
    [userDef synchronize];
    
    NSMutableArray *newImageNames = [NSMutableArray array];
    //判断传入url在缓存数组中是否有对应存在
    NSInteger cacheCount=caches.count;
    NSInteger urlCount = newData.count;
    
    for (int i=0; i<urlCount;i++) {
        //如果传入数组小于缓存数组,先删除对应,后下载并更新沙盒
        if (i<cacheCount-1) {
            NSString *imgName_cached=caches[i];
            NSString *imgName_url = [newData[i] componentsSeparatedByString:@"/"].lastObject;
            if (![imgName_cached isEqualToString:imgName_url]) {
                    //下载并写入
                    NSString *fileName = [self writeFileWithUrl:newData[i]];
                    if (fileName) {
                        [NSObject removeFileWithName:imgName_cached];
                    }
                
                    [newImageNames addObject:fileName];
            }
            //传入数组大于缓存数组,直接更新
        }else{
            //下载并写入
            NSString *fileName = [self writeFileWithUrl:newData[i]];
            
            [newImageNames addObject:fileName];
        }
    }
    
    return newImageNames;
}



/**下载数据并缓存到沙盒*/
+(void) downDataWithUrls:(NSMutableArray *) imageUrls boundingParams:(NSMutableArray *) boundingParams{
    //清除相关索引参数
    [userDef removeObjectForKey:key_names];
    [userDef removeObjectForKey:key_params];
    [userDef synchronize];

    NSString *path = [self directory];
    if (path) {
        NSMutableArray *imagePathArr = [NSMutableArray array];
        for (NSString* imgUrl in imageUrls) {
            //下载图片
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
            if (imgData) {
                UIImage *image =  [UIImage imageWithData:imgData];
                //写入缓存
                NSString *imageName = [imgUrl componentsSeparatedByString:@"/"].lastObject;
                NSString *filePath = [path stringByAppendingPathComponent:imageName];
                
                if([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]){
                    //保存缓存的图片路径
                    [imagePathArr addObject:imageName];
                }else{
                    NSLog(@"SYAdLaunchView,图片缓存写入失败");
                }
            }
        }
        //将图片路径数组,图片参数数组缓存
        [userDef setObject:imagePathArr forKey:key_names];
        [userDef setObject:boundingParams forKey:key_params];
        [userDef synchronize];
    }
}

//创建保存目录，返回路径
+(NSString *) directory{
    
    NSString *path_save = [NSObject cacheDir];
    
    BOOL isDir=YES;
    if (![fileManager fileExistsAtPath:path_save isDirectory:&isDir]) {
        NSError* error_create;
        [fileManager createDirectoryAtPath:path_save withIntermediateDirectories:YES attributes:nil error:&error_create];
        
        if (error_create) {
            NSLog(@"创建保存SYAdLaunchCaches目录失败,error=%@",error_create);
        }
    }
    
    return path_save;
}


//下载url数据并写入沙盒
+(NSString *) writeFileWithUrl:(NSString *) url{
    NSData *data_url =[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];

    if (data_url) {
        UIImage *imgObj_url = [UIImage imageWithData:data_url];
        NSString *fileName = [url componentsSeparatedByString:@"/"].lastObject;
        NSString*path_write =[[NSObject cacheDir] stringByAppendingPathComponent:fileName];
        if ([UIImagePNGRepresentation(imgObj_url) writeToFile:path_write atomically:YES]) {
            return fileName;
        }else{
            NSLog(@"SYAdLaunchView,图片缓存写入失败");
            return nil;
        }
    }else{
        NSLog(@"SYAdLaunchView,图片下载失败");
        return nil;
    }
}

@end
