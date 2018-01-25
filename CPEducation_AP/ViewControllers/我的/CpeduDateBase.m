//
//  CpeduDateBase.m
//  CPEducation_AP
//
//  Created by lishouping on 2017/10/12.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import "CpeduDateBase.h"

@implementation CpeduDateBase
+(id)shareInstance
{
    static id shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        //数据库路径
        NSString * path=[NSString stringWithFormat:@"%@/Documents/cpjw.db",NSHomeDirectory()];
        shareInstance=[[CpeduDateBase alloc]initWithPath:path];
        
    });
    return shareInstance;
}
-(id)initWithPath:(NSString *)path
{
    //创建数据库
    self=[super initWithPath:path];
    if (self)
    {
        //打开数据库
        if ([self open])
        {
            BOOL isSucceed=[self executeUpdate:@"create table Pending (id integer primary key autoincrement,pendingTime,pendingTitle,pendingContent,pendingType)"];
            if (isSucceed)
            {
                NSLog(@"数据库建表成功");
            }
            else
            {
                NSLog(@"数据库建表失败");
            }
            
        }
    }
    return self;
}
@end
