//
//  NoticeModelArray.h
//  CPEducation_AP
//
//  Created by lishouping on 16/12/23.
//  Copyright © 2016年 李寿平. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeModelArray : NSObject
@property(nonatomic,strong)NSString *contentid;//通知id
@property(nonatomic,strong)NSString *title;//主标题
@property(nonatomic,strong)NSString *contenttype;////类型 0：通知；1：会议；2：调查；3：公共信息
@property(nonatomic,strong)NSString *templates; //模板id 0-全文字 1-图上文下 2-图下文上 3-多图 4-视频;
@property(nonatomic,strong)NSString *content;//正文内容
@property(nonatomic,strong)NSArray *picturelist;//图片数组
@property(nonatomic,strong)NSString *signstate;//签收状态(0-未签收 1-已签收)
@property(nonatomic,strong)NSString *mark;//通知标志（0-无标志 2-置顶 1-热点）
@property(nonatomic,strong)NSString *sendtime;//发布时间
@property(nonatomic,strong)NSString *readnumber;//浏览次数
@property(nonatomic,strong)NSString *signnumber;//签收人数
@property(nonatomic,strong)NSString *readLine;//阅后即焚（0-非阅后即焚 1-阅后即焚）
@property(nonatomic,strong)NSString *video_url;// 视频地址
@property(nonatomic,strong)NSString *link_url;// 视频地址

@property(nonatomic,strong)NSString *attendstate;//参加状态
@property(nonatomic,strong)NSString *attendnumber;//参加人数
@property(nonatomic,strong)NSString *messagenumber;//会议教委回复消息数量

@property(nonatomic,strong)NSString *surveystate;////调查状态(0-未投 1-已投 2-结束) –调查
@property(nonatomic,strong)NSString *surveynumber;//投票数量
@property(nonatomic,strong)NSString *favoriteid;



@end
