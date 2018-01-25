//
//  NoticeTableViewCell.m
//  CPEducation_AP
//
//  Created by lishouping on 16/12/22.
//  Copyright © 2016年 李寿平. All rights reserved.
//

#import "NoticeTableViewCell.h"

@implementation NoticeTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
       [self makeUIkeyWrds];
        
    }
    return self;
}
// 纯文字
- (void)makeUIkeyWrds{
    self.labNoticeContent = [UILabel new];
    self.labNoticeContent.text = @"测试测试测试测试测试测试测试测试测试测试测试测试测测试测试测试测试测试测试测测试测试测试测试测试测试测测试测试测试测试测试测试测试";
    [self.contentView addSubview:self.labNoticeContent];
    [self.labNoticeContent setTextColor:[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1]];
    self.labNoticeContent.font = [UIFont systemFontOfSize:11];
     self.labNoticeContent
    .sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(60);
    self.labNoticeContent.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    self.labNoticeContent.numberOfLines = 3;
}
// 图前文后
-(void)setImageUp{
    self.imgNotice = [UIImageView new];
    self.imgNotice.frame = CGRectMake(10, 10, 70, 70);
    [self.imgNotice setImage:[UIImage imageNamed:@"icon0.jpg"]];
    [self.contentView addSubview:self.imgNotice];
    
    self.labNoticeContent = [UILabel new];
    self.labNoticeContent.text = @"测试测试测试测试测试测试测试测试测试测试测试测试测测试测试测试测试测试测试测测试测试测试测试测试测试测测试测试测试测试测试测试测试";
    self.labNoticeContent.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    [self.contentView addSubview:self.labNoticeContent];
    self.labNoticeContent.font = [UIFont systemFontOfSize:14];
    self.labNoticeContent
    .sd_layout
    .leftSpaceToView(self.contentView, 10+70+10)
    .topSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(60);
    self.labNoticeContent.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    self.labNoticeContent.numberOfLines = 3;

}

// 图后文前
-(void)setImageDown{
    self.imgNotice = [UIImageView new];
    self.imgNotice.frame = CGRectMake(kWidth-10-70, 10, 70, 70);
    [self.imgNotice setImage:[UIImage imageNamed:@"icon0.jpg"]];
    [self.contentView addSubview:self.imgNotice];
    
    self.labNoticeContent = [UILabel new];
    self.labNoticeContent.text = @"测试测试测试测试测试测试测试测试测试测试测试测试测测试测试测试测试测试测试测测试测试测试测试测试测试测测试测试测试测试测试测试测试";
    self.labNoticeContent.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    [self.contentView addSubview:self.labNoticeContent];
    self.labNoticeContent.font = [UIFont systemFontOfSize:11];
    self.labNoticeContent
    .sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 10+70+10)
    .heightIs(60);
    self.labNoticeContent.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    self.labNoticeContent.numberOfLines = 3;
    
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
