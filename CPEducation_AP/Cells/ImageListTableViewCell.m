//
//  ImageListTableViewCell.m
//  CPEducation_AP
//
//  Created by lishouping on 17/2/14.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import "ImageListTableViewCell.h"

@implementation ImageListTableViewCell
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
    self.pictureImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, kWidth-10-10, 130)];
    [self.contentView addSubview:self.pictureImage];
    
    self.captionLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, kWidth-10-10, 20)];
    [self.captionLab setFont:[UIFont systemFontOfSize:11]];
    self.captionLab.numberOfLines = 5;
    [self.captionLab setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]];
    [self.contentView addSubview:self.captionLab];
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
