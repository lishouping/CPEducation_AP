//
//  MettingFootView.h
//  CPEducation_AP
//
//  Created by lishouping on 2017/6/26.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MettingFootView : UIView
@property(nonatomic,strong)UILabel *labNoticeCreateTime;//创建时间
@property(nonatomic,strong)UILabel *labNoticeReadNum;//阅读人数
@property(nonatomic,strong)UILabel *labNoticeFabulous;//点赞人数
@property(nonatomic,strong)UIView *viewNoticeType;//通知类型、、置顶 热
@property(nonatomic,strong)UILabel *labNoticeType;
@property(nonatomic,strong)UIView *viewNoticeLineType;//通知类型、、焚
@property(nonatomic,strong)UILabel *labNoticeLineType;
@end
