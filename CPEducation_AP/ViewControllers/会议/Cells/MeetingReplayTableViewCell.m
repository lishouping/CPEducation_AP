//
//  MeetingReplayTableViewCell.m
//  CPEducation_AP
//
//  Created by lishouping on 2017/6/28.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import "MeetingReplayTableViewCell.h"

@implementation MeetingReplayTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}
- (void)makeUI{
    self.imgUser = [UIImageView new];
    [self.imgUser setImage:[UIImage imageNamed:@"cp_replayuser"]];
    [self.contentView addSubview:self.imgUser];
    [self.imgUser zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpace(10);
        layout.leftSpace(10);
        layout.widthValue(30);
        layout.heightValue(30);
    }];
    
    self.lableUser = [UILabel new];
    [self.lableUser setFont:[UIFont systemFontOfSize:15]];
    [self.lableUser setTextColor:[UIColor blackColor]];
    [self.contentView addSubview:self.lableUser];
    [self.lableUser zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpace(10);
        layout.leftSpaceByView(self.imgUser, 10);
        layout.widthValue(100);
        layout.heightValue(30);
    }];
    
    self.labTime = [UILabel new];
    [self.labTime setFont:[UIFont systemFontOfSize:13]];
    [self.labTime setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:self.labTime];
    [self.labTime zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpace(10);
        layout.leftSpaceByView(self.lableUser, 20);
        layout.widthValue(120);
        layout.heightValue(30);
    }];
    
    self.btnDel = [UIButton new];
    [self.btnDel setImage:[UIImage imageNamed:@"detele"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.btnDel];
    [self.btnDel zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpace(15);
        layout.rightSpace(10);
        layout.widthValue(20);
        layout.heightValue(20);
    }];
    
    
    self.labMessage = [UILabel new];
    [self.labMessage setFont:[UIFont systemFontOfSize:13]];
    [self.labMessage setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:self.labMessage];
    [self.labMessage zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpaceByView(self.lableUser, 0);
        layout.leftSpace(50);
        layout.widthValue(kWidth-10-10);
        layout.heightValue(30);
    }];
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
