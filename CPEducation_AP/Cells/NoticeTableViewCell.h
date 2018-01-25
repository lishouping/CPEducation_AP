//
//  NoticeTableViewCell.h
//  CPEducation_AP
//
//  Created by lishouping on 16/12/22.
//  Copyright © 2016年 李寿平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeModelArray.h"

@interface NoticeTableViewCell : UITableViewCell

@property(nonatomic,strong)NoticeModelArray *noticeModel;
@property(nonatomic,strong)UILabel *labNoticeContent;//内容
- (void)setModel:(NoticeModelArray *)noticeModel;
@property(nonatomic,strong)UIImageView *imgNotice;
@end
