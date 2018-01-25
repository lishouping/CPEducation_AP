//
//  NSString+Jeson.m
//  sanxingshengtai
//
//  Created by HFL on 15-1-22.
//  Copyright (c) 2015年 HuangFengli. All rights reserved.
//

#import "NSString+Jeson.h"

@implementation NSString (Jeson)
//将字符串  转成数组或者字典
-(id)convertToID
{
    NSError *err;
    //先去掉 字符串中的\r \t \n   json数据当中没有 \n \r \t 等制表符
    NSString * str=self;
    str = [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    //NSLog(@"convertToID error=%@",err.description);
    return result;
}
@end
