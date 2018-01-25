//
//  PendingModel.h
//  CPEducation_AP
//
//  Created by lishouping on 2017/10/12.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendingModel : NSObject
@property(nonatomic,strong)NSString *pendingid;
@property(nonatomic,strong)NSString *pendingTime;//待办提醒时间
@property(nonatomic,strong)NSString *pendingTitle;//待办事情标题
@property(nonatomic,strong)NSString *pendingContent;//待办内容
@property(nonatomic,strong)NSString *pendingType;////待办提醒状态（0-未提醒 1-已提醒）
@end
