//
//  SurveyQuestionModel.h
//  CPEducation_AP
//
//  Created by lishouping on 2017/6/30.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SurveyQuestionModel : NSObject
@property(nonatomic,strong)NSString *voteid;//投票项ID
@property(nonatomic,strong)NSString *votetitle;//投票标题
@property(nonatomic,strong)NSString *votestate;//投票状态
@property(nonatomic,strong)NSString *votenumber;// 得票数量
@property(nonatomic,strong)NSString *ranking;//投票排名
@property(nonatomic,strong)NSString *contentid;//内容id
@property(nonatomic,strong)NSString *optionrecordid;//选择id
@end
