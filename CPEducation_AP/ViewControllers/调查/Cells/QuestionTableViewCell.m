//
//  QuestionTableViewCell.m
//  CPEducation_AP
//
//  Created by lishouping on 2017/6/30.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import "QuestionTableViewCell.h"

@implementation QuestionTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}

- (void)makeUI{
    UIView *cellView = [UIView new];
    [cellView setBackgroundColor:[UIColor colorWithRed:118.0/255.0 green:195.0/255.0 blue:247.0/255.0 alpha:1]];
    [self.contentView addSubview:cellView];
    [cellView zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(0);
        layout.rightSpace(0);
        layout.widthValue(50);
        layout.heightValue(50);
    }];
    
    
    self.labQueNumber = [UILabel new];
    [self.labQueNumber setTextColor:[UIColor whiteColor]];
    [self.labQueNumber setText:@"1"];
    [cellView addSubview:self.labQueNumber];
    [self.labQueNumber zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(10);
        layout.topSpace(10);
        layout.widthValue(30);
        layout.heightValue(30);
    }];
    
    self.labQueTitle = [UILabel new];
    [self.labQueTitle setTextColor:[UIColor whiteColor]];
    [cellView addSubview:self.labQueTitle];
    [self.labQueTitle zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpace(10);
        layout.leftSpaceByView(self.labQueNumber, 20);
        layout.widthValue(kWidth-10-10-80);
        layout.heightValue(30);
    }];
    
    
    self.imgvOne = [UIImageView new];
    [cellView addSubview:self.imgvOne];
    [self.imgvOne zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.rightSpace(15);
        layout.topSpace(2);
        layout.widthValue(20);
        layout.heightValue(20);
    }];
    [self.imgvOne setImage:[UIImage imageNamed:@"iconesuv"]];
    self.imgvOne.hidden = YES;
    
    self.labRelult = [UILabel new];
    [self.labRelult setTextColor:[UIColor whiteColor]];
    [cellView addSubview:self.labRelult];
    [self.labRelult zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.rightSpace(10);
        layout.topSpace(15);
        layout.widthValue(20);
        layout.heightValue(30);
    }];
    
    
    self.btnQueAnswer = [UIButton new];
    [self.btnQueAnswer setBackgroundColor:[UIColor colorWithRed:16.0/255.0 green:131.0/255.0 blue:226.0/255.0 alpha:1]];
    self.btnQueAnswer.layer.cornerRadius = 5;
    [self.btnQueAnswer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnQueAnswer setTitle:@"投票" forState:UIControlStateNormal];
    [cellView addSubview:self.btnQueAnswer];
    [self.btnQueAnswer zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.rightSpace(10);
        layout.topSpace(10);
        layout.widthValue(50);
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
