//
//  NSMutableArray+ForComparing.m
//  SYAdLaunchViewDemo
//  #####################################################################################
//  为了满足您的个性化需求，该库属性基本上都是暴露的，只要一层一层往下看，应该就可以找到你需要的属性进行修改。:)
//  如有问题请加qq:619023485
//  也可以发送邮件到619023485@qq.com,mingyi_126.com或shionIsMyName@gmail.com.
//  #####################################################################################
//  Created by shiyong on 16/7/3.
//  Copyright © 2016年 sy. All rights reserved.
//

#import "NSMutableArray+ForComparing.h"

@implementation NSMutableArray (ForComparing)

/**比较两个数组中的内容是否完全一致*/
+(BOOL) isThisEqual:(NSMutableArray *) arrA to:(NSMutableArray *) arrB{
    BOOL bol=NO;
    
    
    
    //创建俩新的数组
    NSMutableArray *oldArr = [NSMutableArray array];
    for (NSString *str in arrA) {
        NSString *fileName = [str componentsSeparatedByString:@"/"].lastObject;
        [oldArr addObject:fileName];
    }
    
    NSMutableArray *newArr = [NSMutableArray array];
    for (NSString* str in arrB) {
        NSString *fileName = [str componentsSeparatedByString:@"/"].lastObject;
        [newArr addObject:fileName];
    }
    
    
    
    //上个排序好像不起作用，应采用下面这个
    [oldArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2){return [obj1 localizedStandardCompare: obj2];}];
    
    //上个排序好像不起作用，应采用下面这个
    [newArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2){return [obj1 localizedStandardCompare: obj2];}];
    
    
    if (newArr.count == oldArr.count) {
        
        bol = YES;
        for (int16_t i = 0; i < oldArr.count; i++) {
            
            id c1 = [oldArr objectAtIndex:i];
            
            id newc = [newArr objectAtIndex:i];
            
            if (![newc isEqualToString:c1]) {
                bol = NO;
                break;
            }
        }
    }
    return bol;
}




@end
