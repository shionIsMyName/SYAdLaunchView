//
//  NSMutableArray+ForComparing.h
//  SYAdLaunchViewDemo
//  #####################################################################################
//  为了满足您的个性化需求，该库属性基本上都是暴露的，只要一层一层往下看，应该就可以找到你需要的属性进行修改。:)
//  如有问题请加qq:619023485
//  也可以发送邮件到619023485@qq.com,mingyi_126.com或shionIsMyName@gmail.com.
//  #####################################################################################
//  Created by shiyong on 16/7/3.
//  Copyright © 2016年 sy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (ForComparing)

/**比较两个数组中的内容是否完全一致*/
+(BOOL) isThisEqual:(NSMutableArray *) cached to:(NSMutableArray *) netdata;


@end
