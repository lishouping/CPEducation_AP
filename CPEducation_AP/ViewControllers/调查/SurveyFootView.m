//
//  SurveyFootView.m
//  CPEducation_AP
//
//  Created by lishouping on 2017/6/29.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import "SurveyFootView.h"

@implementation SurveyFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, kWidth, 30)];
    [self addSubview:footView];
    
    self.viewNoticeType = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 30, 15)];
    self.viewNoticeType.layer.borderColor = [[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1] CGColor];
    self.viewNoticeType.layer.borderWidth = 0.5;
    [footView addSubview:self.viewNoticeType];
    
    
    self.labNoticeType = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 15)];
    [self.labNoticeType setText:@"置顶"];
    self.labNoticeType.font = [UIFont systemFontOfSize:8];
    self.labNoticeType.textAlignment = UITextAlignmentCenter;
    [self.labNoticeType setTextColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
    [self.viewNoticeType addSubview:self.labNoticeType];
    
    
    self.viewNoticeLineType = [[UIView alloc] initWithFrame:CGRectMake(10+30+5, 5, 25, 15)];
    self.viewNoticeLineType.layer.borderColor = [[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1] CGColor];
    self.viewNoticeLineType.layer.borderWidth = 0.5;
    [footView addSubview:self.viewNoticeLineType];
    
    
    self.labNoticeLineType = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 15)];
    [self.labNoticeLineType setText:@"焚"];
    self.labNoticeLineType.font = [UIFont systemFontOfSize:8];
    self.labNoticeLineType.textAlignment = UITextAlignmentCenter;
    [self.labNoticeLineType setTextColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
    [self.viewNoticeLineType addSubview:self.labNoticeLineType];
    
    
    self.labNoticeCreateTime = [[UILabel alloc] initWithFrame:CGRectMake(10+30+5+25+5, 5, 200, 15)];
    [self.labNoticeCreateTime setText:@"3分钟前"];
    self.labNoticeCreateTime.font = [UIFont systemFontOfSize:11];
    self.labNoticeCreateTime.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    [footView addSubview:self.labNoticeCreateTime];
    
    UIImageView *imgviews = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth-5-30-30-40, 9, 11, 7)];
    [imgviews setImage:[UIImage imageNamed:@"ic_liulan"]];
    [footView addSubview:imgviews];
    
    self.labNoticeReadNum = [[UILabel alloc] initWithFrame:CGRectMake(kWidth-10-30-50, 5, 30, 15)];
    [self.labNoticeReadNum setText:@"1222"];
    self.labNoticeReadNum.font = [UIFont systemFontOfSize:11];
    self.labNoticeReadNum.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    [footView addSubview:self.labNoticeReadNum];
    
    UIImageView *imgfas = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth-30-18, 7, 7, 11)];
    [imgfas setImage:[UIImage imageNamed:@"ic_dianzan"]];
    [footView addSubview:imgfas];
    
    self.labNoticeFabulous = [[UILabel alloc] initWithFrame:CGRectMake(kWidth-8-20-10, 5, 30, 15)];
    [self.labNoticeFabulous setText:@"143"];
    self.labNoticeFabulous.font = [UIFont systemFontOfSize:10];
    [footView addSubview:self.labNoticeFabulous];
    self.labNoticeFabulous.font = [UIFont systemFontOfSize:11];
    self.labNoticeFabulous.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    self.backgroundColor = [UIColor whiteColor];
    
    //    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 5+15+10, kWidth, 10)];
    //    [lineView setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]];
    //    [footView addSubview:lineView];
    
    
}


@end
