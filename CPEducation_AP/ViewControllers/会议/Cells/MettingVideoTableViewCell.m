//
//  MettingVideoTableViewCell.m
//  CPEducation_AP
//
//  Created by lishouping on 2017/6/26.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import "MettingVideoTableViewCell.h"

@implementation MettingVideoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUIkeyWrds];
    }
    return self;
}

- (void)makeUIkeyWrds{
    self.labNoticeTitle = [UILabel new];
    [self.contentView addSubview:self.labNoticeTitle];
    self.labNoticeTitle.font = [UIFont systemFontOfSize:14];
    [self.labNoticeTitle setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1]];
    [self.labNoticeTitle zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpace(10);
        layout.leftSpace(10);
        layout.rightSpace(50);
        layout.autoHeight();
    }];
    self.labNoticeTitle.numberOfLines = 2;
    
    self.mettingRepNumView = [UIButton new];
    [self addSubview:self.mettingRepNumView];
    [self.mettingRepNumView setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
    self.mettingRepNumView.layer.cornerRadius = 10;
    [self.mettingRepNumView zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.rightSpace(15);
        layout.widthValue(20);
        layout.heightValue(20);
        layout.topSpace(2);
    }];
    
    self.meetingRepNumLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.meetingRepNumLab setText:@"10"];
    self.meetingRepNumLab.textAlignment = UITextAlignmentCenter;
    self.meetingRepNumLab.textColor = [UIColor whiteColor];
    [self.meetingRepNumLab setFont:[UIFont systemFontOfSize:8]];
    [self.mettingRepNumView addSubview:self.meetingRepNumLab];

    
    self.signStateView = [UIView new];
    [self addSubview:self.signStateView];
    [self.signStateView setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
    self.backgroundColor = [UIColor whiteColor];
    [self.signStateView zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.rightSpace(10);
        layout.widthValue(30);
        layout.topSpaceByView(self.mettingRepNumView, 3);
        layout.heightValue(15);
    }];
    
    self.sigState = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 15)];
    self.sigState.textAlignment = UITextAlignmentCenter;
    [self.sigState setFont:[UIFont systemFontOfSize:8]];
    [self.signStateView addSubview:self.sigState];
    
    
    self.imgNotice = [UIImageView new];
    [self.imgNotice setImage:[UIImage imageNamed:@"picture_video"]];
    [self.contentView addSubview:self.imgNotice];
    [self.imgNotice zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpaceByView(self.labNoticeTitle,5);
        layout.leftSpace(kWidth/2-35);
        layout.widthValue(70);
        layout.heightValue(70);
    }];
    
    
}
- (void)setModel:(NoticeModelArray *)noticeModel{
    self.labNoticeTitle.text = noticeModel.title;
    NSNumber *number =  @([noticeModel.messagenumber intValue]);
    NSString *strnumber = [NSString stringWithFormat:@"%@",number];
    if ([strnumber isEqualToString:@"0"]) {
        self.mettingRepNumView.hidden = YES;
    }else{
        self.mettingRepNumView.hidden = NO;
    }
    self.meetingRepNumLab.text = strnumber;
    if ([noticeModel.attendstate isEqualToString:@"1"]) {//已签收
        [self.signStateView setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
        [self.sigState setTextColor:[UIColor whiteColor]];
        [self.sigState setText:@"不参加"];
    }else if ([noticeModel.attendstate isEqualToString:@"0"]){
        [self.signStateView setBackgroundColor:[UIColor whiteColor]];
        [self.sigState setTextColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
        [self.sigState setText:@"待参加"];
        self.signStateView.layer.borderWidth = 0.5;
        self.signStateView.layer.borderColor =[[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1] CGColor];
    }else if ([noticeModel.attendstate isEqualToString:@"2"]){
        [self.signStateView setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
        [self.sigState setTextColor:[UIColor whiteColor]];
        [self.sigState setText:@"已参加"];
    }else if ([noticeModel.attendstate isEqualToString:@"3"]){
        [self.signStateView setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
        [self.sigState setTextColor:[UIColor whiteColor]];
        [self.sigState setText:@"已签到"];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
