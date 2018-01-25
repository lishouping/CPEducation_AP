//
//  PendingTableViewCell.m
//  CPEducation_AP
//
//  Created by lishouping on 2017/7/6.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import "PendingTableViewCell.h"

@implementation PendingTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self makeUI];
        
    }
    return self;
}
- (void)makeUI{
    self.labTime = [UILabel new];
    [self.labTime setText:@"12:20"];
    [self.labTime setTextColor:[UIColor grayColor]];
    [self.labTime setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:self.labTime];
    [self.labTime zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpace(10);
        layout.leftSpace(10);
        layout.bottomSpace(10);
        layout.heightValue(20);
        layout.widthValue(60);
    }];
    
    UIView *linView = [UIView new];
    [linView setBackgroundColor:[UIColor colorWithRed:12/255.0 green:134/255.0 blue:237/255.0 alpha:1]];
    [self.contentView addSubview:linView];
    [linView zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpace(0);
        layout.bottomSpace(0);
        layout.leftSpaceByView(self.labTime, 10);
        layout.widthValue(1);
        layout.heightValue(40);
    }];
    
    self.labTitle = [UILabel new];
    [self.labTitle setTextColor:[UIColor grayColor]];
    [self.labTitle setText:@"这是待办"];
    [self.labTitle setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:self.labTitle];
    [self.labTitle zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpace(10);
        layout.leftSpaceByView(linView, 10);
        layout.autoWidth();
        layout.autoHeight();
    }];
    
    
    UIView *tabview = [UIView new];
    [tabview setBackgroundColor:[UIColor colorWithRed:12/255.0 green:134/255.0 blue:237/255.0 alpha:1]];
    [self.contentView addSubview:tabview];
    [tabview zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpaceByView(self.labTitle, 10);
        layout.leftSpaceByView(linView, 10);
        layout.rightSpace(10);
        layout.autoWidth();
        layout.heightValue(1);
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
