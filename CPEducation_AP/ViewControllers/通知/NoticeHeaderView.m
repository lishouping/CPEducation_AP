//
//  NoticeHeaderView.m
//  CPEducation_AP
//
//  Created by lishouping on 16/12/23.
//  Copyright © 2016年 李寿平. All rights reserved.
//

#import "NoticeHeaderView.h"

@implementation NoticeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.labNoticeTitle = [UILabel new];
    self.labNoticeTitle.text = @"测试测试测试测试测试测试测试测试测试测试测试测试测测试测试测试测试测试测试测测试测试测试测试测试测试测测试测试测试测试测试测试测试";
    [self addSubview:self.labNoticeTitle];
    self.labNoticeTitle.font = [UIFont systemFontOfSize:14];
    [self.labNoticeTitle setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1]];
    self.labNoticeTitle
    .sd_layout
    .leftSpaceToView(self, 10)
    .topSpaceToView(self, 0)
    .rightSpaceToView(self, 50)
    .heightIs(40);
     self.labNoticeTitle.font = [UIFont systemFontOfSize:14];
     self.labNoticeTitle.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
     self.labNoticeTitle.numberOfLines = 2;
      
    self.signStateView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth-35, 20, 30, 15)];
    [self addSubview:self.signStateView];
    [self.signStateView setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
    self.backgroundColor = [UIColor whiteColor];
    
    self.sigState = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 15)];
    [self.sigState setText:@"未签收"];
    self.sigState.textAlignment = UITextAlignmentCenter;
    [self.sigState setFont:[UIFont systemFontOfSize:8]];
    [self.signStateView addSubview:self.sigState];
    
    
    
}

@end
