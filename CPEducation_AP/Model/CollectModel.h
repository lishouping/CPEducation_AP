//
//  CollectModel.h
//  CPEducation_AP
//
//  Created by lishouping on 2017/10/11.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectModel : NSObject
@property(nonatomic,strong)NSString *favoriteid;//收藏id
@property(nonatomic,strong)NSString *contenttype;////类型 0：通知；1：会议；2：调查；3：公共信息
@property(nonatomic,strong)NSString *template;//模板id 0-全文字 1-图上文下 2-图下文上 3-多图 4-视频
@property(nonatomic,strong)NSString *contentid;//内容id
@property(nonatomic,strong)NSString *title;//主标题
@property(nonatomic,strong)NSString *content;//内容
@property(nonatomic,strong)NSString *signstate;////签收状态(0-未签收 1-已签收)
@property(nonatomic,strong)NSString *mark;//mark
@property(nonatomic,strong)NSString *readLine;// 阅后即焚（0-非阅后即焚 1-阅后即焚）
@property(nonatomic,strong)NSString *sendtime;//发布时间
@property(nonatomic,strong)NSString *readnumber;////浏览次数
@property(nonatomic,strong)NSString *signnumber;//签收次数
@property(nonatomic,strong)NSString *attendstate;////参与状态(0-待参加 1-不参加 2-已参加 3-已签到) -会议
@property(nonatomic,strong)NSString *attendnumber;//参加人数-会议
@property(nonatomic,strong)NSArray *picturelist;//图片数组
@property(nonatomic,strong)NSString *messagenumber;///回复消息条数（超过99条显示”…”） -会议
@property(nonatomic,strong)NSString *surveystate;
@property(nonatomic,strong)NSString *surveynumber;
@end
