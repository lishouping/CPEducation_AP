//
//  MineAnnexTableViewCell.m
//  CPEducation_AP
//
//  Created by lishouping on 17/2/12.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import "MineAnnexTableViewCell.h"

@implementation MineAnnexTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self makUI];
        
    }
    return self;
}
- (void)makUI{
    self.annexImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    [self.contentView addSubview:self.annexImg];
    
    self.annexName = [[UILabel alloc] initWithFrame:CGRectMake(10+30, 10, kWidth-(10+30)-50, 20)];
    [self.annexName setText:@"昌平教委.png"];
    [self.annexName setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:self.annexName];
    
    self.annexDelete = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-30,10, 20, 20)];
    [self.annexDelete setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.annexDelete];
    
    
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
