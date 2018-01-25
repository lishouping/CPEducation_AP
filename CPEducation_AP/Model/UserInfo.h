//
//  UserInfo.h
//  CPEducation_AP
//
//  Created by lishouping on 17/3/4.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property (nonatomic, readonly) BOOL isLoggedIn;

+ (instancetype)sharedClient;
@end
