//
//  NSObject+SandboxOps.m
//  SYAdLaunchViewDemo
//  #####################################################################################
//  为了满足您的个性化需求，该库属性基本上都是暴露的，只要一层一层往下看，应该就可以找到你需要的属性进行修改。:)
//  如有问题请加qq:619023485
//  也可以发送邮件到619023485@qq.com,mingyi_126.com或shionIsMyName@gmail.com.
//  #####################################################################################
//  Created by shiyong on 16/7/3.
//  Copyright © 2016年 sy. All rights reserved.
//

#import "NSObject+SandboxOps.h"
#define subDir @"SYAdLaunchView"



@implementation NSObject (SandboxOps)
/**获取缓存文件夹路径*/
+(NSString*) cacheDir{
    NSString *prefix =NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    
    return [prefix stringByAppendingPathComponent:subDir];
}

/**根据名字删文件*/
+(BOOL) removeFileWithName:(NSString *) filePath{
    BOOL result = NO;
    
    NSString *removePath = [[NSObject cacheDir] stringByAppendingPathComponent:filePath];
    BOOL isDir = NO;
    if ([fileManager fileExistsAtPath:removePath isDirectory:&isDir]) {
        NSError *removeError;
        [fileManager removeItemAtPath:removePath error:&removeError];
        if (removeError) {
            NSLog(@"SYAdLaunchView删除旧文件失败,error=>%@",removeError);
            return result;
        }else{
            result=YES;
            return result;
        }
    }else{
        return result;
    }

}





@end
