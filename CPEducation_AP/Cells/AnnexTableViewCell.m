//
//  AnnexTableViewCell.m
//  CPEducation_AP
//
//  Created by lishouping on 17/2/10.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import "AnnexTableViewCell.h"

@implementation AnnexTableViewCell
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
    self.annexImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    [self.contentView addSubview:self.annexImg];
    
    self.annexName = [[UILabel alloc] initWithFrame:CGRectMake(10+30, 5, kWidth-(10+30), 20)];
    [self.annexName setText:@"昌平教委.png"];
    [self.annexName setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:self.annexName];
                                                    
    
    
    
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
