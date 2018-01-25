//
//  AppDelegate.h
//  CPEducation_AP
//
//  Created by lishouping on 16/12/22.
//  Copyright © 2016年 李寿平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CpeduDateBase.h"
static NSString *appKey = @"aca0e06df4231af5d06f7934";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong)NSString *isLogin;//1登录了 0未登录
@property (nonatomic,strong)CpeduDateBase *cpeduDateBase;
@property (nonatomic,strong)NSString *pagerefresh;
@end

