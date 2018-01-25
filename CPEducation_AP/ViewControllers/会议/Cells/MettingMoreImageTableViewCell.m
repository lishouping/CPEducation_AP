//
//  MettingMoreImageTableViewCell.m
//  CPEducation_AP
//
//  Created by lishouping on 2017/6/26.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import "MettingMoreImageTableViewCell.h"

@implementation MettingMoreImageTableViewCell

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
    [self.imgNotice setBackgroundColor:[UIColor grayColor]];
    [self.contentView addSubview:self.imgNotice];
    [self.imgNotice zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(10);
        layout.topSpace(45);
        layout.widthValue((kWidth-10-10-5-5)/3);
        layout.heightValue((kWidth-10-10-5-5)/3);
    }];
    
    self.imgNotice1 = [UIImageView new];
    [self.imgNotice1 setBackgroundColor:[UIColor grayColor]];
    [self.contentView addSubview:self.imgNotice1];
    [self.imgNotice1 zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(10+(kWidth-10-10-5-5)/3+5);
        layout.topSpace(45);
        layout.widthValue((kWidth-10-10-5-5)/3);
        layout.heightValue((kWidth-10-10-5-5)/3);
    }];
    
    self.imgNotice2 = [UIImageView new];
    [self.imgNotice2 setBackgroundColor:[UIColor grayColor]];
    [self.contentView addSubview:self.imgNotice2];
    [self.imgNotice2 zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(10+(kWidth-10-10-5-5)/3+5+5+(kWidth-10-10-5-5)/3);
        layout.topSpace(45);
        layout.widthValue((kWidth-10-10-5-5)/3);
        layout.heightValue((kWidth-10-10-5-5)/3);
    }];
    
    self.imgNotice.hidden = YES;
    self.imgNotice1.hidden = YES;
    self.imgNotice2.hidden = YES;
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
    
    NSArray *dateArray = noticeModel.picturelist;
    NSString *picture;
    for (NSDictionary * dic in dateArray)
    {
        picture = [dic objectForKey:@"picture"];
    }
    if (dateArray.count==1) {//一张图
        NSString *pic = [[dateArray objectAtIndex:0] objectForKey:@"picture"];
        NSURL *url = [[NSURL alloc] initWithString:pic];
        [self.imgNotice sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default"]];
        self.imgNotice.hidden = NO;
        self.imgNotice1.hidden = YES;
        self.imgNotice2.hidden = YES;
    }else if (dateArray.count==2){
        NSString *pic = [[dateArray objectAtIndex:0] objectForKey:@"picture"];
        NSURL *url = [[NSURL alloc] initWithString:pic];
        [self.imgNotice sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default"]];
        self.imgNotice.hidden = NO;
        NSString *pic1 = [[dateArray objectAtIndex:1] objectForKey:@"picture"];
        NSURL *url1 = [[NSURL alloc] initWithString:pic1];
        [self.imgNotice1 sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"default"]];
        self.imgNotice1.hidden = NO;
        self.imgNotice2.hidden = YES;
    }else if (dateArray.count==3){
        NSString *pic = [[dateArray objectAtIndex:0] objectForKey:@"picture"];
        NSURL *url = [[NSURL alloc] initWithString:pic];
        [self.imgNotice sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default"]];
        self.imgNotice.hidden = NO;
        NSString *pic1 = [[dateArray objectAtIndex:1] objectForKey:@"picture"];
        NSURL *url1 = [[NSURL alloc] initWithString:pic1];
        [self.imgNotice1 sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"default"]];
        self.imgNotice1.hidden = NO;
        NSString *pic2 = [[dateArray objectAtIndex:2] objectForKey:@"picture"];
        NSURL *url2 = [[NSURL alloc] initWithString:pic2];
        [self.imgNotice2 sd_setImageWithURL:url2 placeholderImage:[UIImage imageNamed:@"default"]];
        self.imgNotice2.hidden = NO;
    }else{
        NSString *pic = [[dateArray objectAtIndex:0] objectForKey:@"picture"];
        NSURL *url = [[NSURL alloc] initWithString:pic];
        [self.imgNotice sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default"]];
        self.imgNotice.hidden = NO;
        NSString *pic1 = [[dateArray objectAtIndex:1] objectForKey:@"picture"];
        NSURL *url1 = [[NSURL alloc] initWithString:pic1];
        [self.imgNotice1 sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"default"]];
        self.imgNotice1.hidden = NO;
        NSString *pic2 = [[dateArray objectAtIndex:2] objectForKey:@"picture"];
        NSURL *url2 = [[NSURL alloc] initWithString:pic2];
        [self.imgNotice2 sd_setImageWithURL:url2 placeholderImage:[UIImage imageNamed:@"default"]];
        self.imgNotice2.hidden = NO;
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
