//
//  SurveyImageUpTableViewCell.m
//  CPEducation_AP
//
//  Created by lishouping on 2017/6/29.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import "SurveyImageUpTableViewCell.h"

@implementation SurveyImageUpTableViewCell

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
    
    self.signStateView = [UIView new];
    [self addSubview:self.signStateView];
    [self.signStateView setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
    self.backgroundColor = [UIColor whiteColor];
    [self.signStateView zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.rightSpace(10);
        layout.widthValue(30);
        layout.topSpace(10);
        layout.heightValue(15);
    }];
    
    self.sigState = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 15)];
    [self.sigState setText:@"未签收"];
    self.sigState.textAlignment = UITextAlignmentCenter;
    [self.sigState setFont:[UIFont systemFontOfSize:8]];
    [self.signStateView addSubview:self.sigState];
    
    
    self.imgNotice = [UIImageView new];
    [self.contentView addSubview:self.imgNotice];
    [self.imgNotice zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpaceByView(self.labNoticeTitle,5);
        layout.leftSpace(10);
        layout.heightValue(70);
        layout.widthValue(70);
    }];
    
    self.labNoticeContent = [UILabel new];
    [self.contentView addSubview:self.labNoticeContent];
    [self.labNoticeContent setTextColor:[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1]];
    self.labNoticeContent.font = [UIFont systemFontOfSize:11];
    [self.labNoticeContent zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpaceByView(self.labNoticeTitle,5);
        layout.leftSpaceByView(self.imgNotice,10);
        layout.rightSpace(10);
        layout.autoHeight();
    }];
    self.labNoticeContent.numberOfLines = 3;
    
}
- (void)setModel:(NoticeModelArray *)noticeModel{
    self.labNoticeTitle.text = noticeModel.title;
    if ([noticeModel.surveystate isEqualToString:@"1"]) {
        [self.signStateView setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
        [self.sigState setTextColor:[UIColor whiteColor]];
        [self.sigState setText:@"已投票"];
    }else if ([noticeModel.surveystate isEqualToString:@"0"]){
        [self.signStateView setBackgroundColor:[UIColor whiteColor]];
        [self.sigState setTextColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
        [self.sigState setText:@"未投票"];
        self.signStateView.layer.borderWidth = 0.5;
        self.signStateView.layer.borderColor =[[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1] CGColor];
    }else if ([noticeModel.surveystate isEqualToString:@"2"]){
        [self.signStateView setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
        [self.sigState setTextColor:[UIColor whiteColor]];
        [self.sigState setText:@"已结束"];
    }
    self.labNoticeContent.text = noticeModel.content;
    
    NSArray *dateArray = noticeModel.picturelist;
    if (dateArray.count>0) {
        NSString *picture;
        for (NSDictionary * dic in dateArray)
        {
            picture = [dic objectForKey:@"picture"];
        }
        NSURL *url = [[NSURL alloc] initWithString:picture];
        [self.imgNotice sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default"]];
        
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
