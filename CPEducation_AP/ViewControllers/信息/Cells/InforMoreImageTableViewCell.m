//
//  InforMoreImageTableViewCell.m
//  CPEducation_AP
//
//  Created by lishouping on 2017/6/29.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import "InforMoreImageTableViewCell.h"

@implementation InforMoreImageTableViewCell

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
    
//    self.signStateView = [UIView new];
//    [self addSubview:self.signStateView];
//    [self.signStateView setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
//    self.backgroundColor = [UIColor whiteColor];
//    [self.signStateView zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
//        layout.rightSpace(10);
//        layout.widthValue(30);
//        layout.topSpace(10);
//        layout.heightValue(15);
//    }];
//    
//    self.sigState = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 15)];
//    self.sigState.textAlignment = UITextAlignmentCenter;
//    [self.sigState setFont:[UIFont systemFontOfSize:8]];
//    [self.signStateView addSubview:self.sigState];
    
    
    self.imgNotice = [UIImageView new];
    [self.imgNotice setBackgroundColor:[UIColor grayColor]];
    [self.contentView addSubview:self.imgNotice];
    [self.imgNotice zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(10);
        layout.topSpaceByView(self.labNoticeTitle,5);
        layout.widthValue((kWidth-10-10-5-5)/3);
        layout.heightValue((kWidth-10-10-5-5)/3);
    }];
    
    self.imgNotice1 = [UIImageView new];
    [self.imgNotice1 setBackgroundColor:[UIColor grayColor]];
    [self.contentView addSubview:self.imgNotice1];
    [self.imgNotice1 zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(10+(kWidth-10-10-5-5)/3+5);
        layout.topSpaceByView(self.labNoticeTitle,5);
        layout.widthValue((kWidth-10-10-5-5)/3);
        layout.heightValue((kWidth-10-10-5-5)/3);
    }];
    
    self.imgNotice2 = [UIImageView new];
    [self.imgNotice2 setBackgroundColor:[UIColor grayColor]];
    [self.contentView addSubview:self.imgNotice2];
    [self.imgNotice2 zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(10+(kWidth-10-10-5-5)/3+5+5+(kWidth-10-10-5-5)/3);
        layout.topSpaceByView(self.labNoticeTitle,5);
        layout.widthValue((kWidth-10-10-5-5)/3);
        layout.heightValue((kWidth-10-10-5-5)/3);
    }];
    
    self.imgNotice.hidden = YES;
    self.imgNotice1.hidden = YES;
    self.imgNotice2.hidden = YES;
}
- (void)setModel:(NoticeModelArray *)noticeModel{
    self.labNoticeTitle.text = noticeModel.title;
//    if ([noticeModel.surveystate isEqualToString:@"0"]) {
//        [self.signStateView setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
//        [self.sigState setTextColor:[UIColor whiteColor]];
//        [self.sigState setText:@"已投票"];
//    }else if ([noticeModel.surveystate isEqualToString:@"1"]){
//        [self.signStateView setBackgroundColor:[UIColor whiteColor]];
//        [self.sigState setTextColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
//        [self.sigState setText:@"未投票"];
//        self.signStateView.layer.borderWidth = 0.5;
//        self.signStateView.layer.borderColor =[[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1] CGColor];
//    }else if ([noticeModel.surveystate isEqualToString:@"2"]){
//        [self.signStateView setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
//        [self.sigState setTextColor:[UIColor whiteColor]];
//        [self.sigState setText:@"已结束"];
//    }
    
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
