//
//  MettingVideoTableViewCell.h
//  CPEducation_AP
//
//  Created by lishouping on 2017/6/26.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeModelArray.h"

@interface MettingVideoTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *labNoticeTitle;//标题
@property(nonatomic,strong)UIButton *mettingRepNumView;//会议回复背景
@property(nonatomic,strong)UILabel *meetingRepNumLab;//会议回复数量
@property(nonatomic,strong)UIView *signStateView;//签收状态背景
@property(nonatomic,strong)UILabel *sigState;//签收状态
@property(nonatomic,strong)UILabel *labNoticeContent;//内容
@property(nonatomic,strong)UIImageView *imgNotice;//图片展示

@property(nonatomic,strong)NoticeModelArray *noticeModel;

- (void)setModel:(NoticeModelArray *)noticeModel;
@end
