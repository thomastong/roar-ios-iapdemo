//
//  IPAListCell.m
//  iaptest01
//
//  Created by administrator on 23/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IAPListCell.h"


@implementation IAPListCell
@synthesize primaryLabel, secondaryLabel, imageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        primaryLabel=[[UILabel alloc]init];
        primaryLabel.textAlignment=UITextAlignmentLeft;
        primaryLabel.font=[UIFont systemFontOfSize:14];
        
        secondaryLabel=[[UILabel alloc]init];
        secondaryLabel.textAlignment=UITextAlignmentLeft;
        secondaryLabel.font=[UIFont systemFontOfSize:8];
        
        imageView = [[UIImageView alloc] init];
        
        [self.contentView addSubview:primaryLabel];
        [self.contentView addSubview:secondaryLabel];
        [self.contentView addSubview:imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;

    imageView.frame = CGRectMake(boundsX+10, 0, 50, 50);
    primaryLabel.frame = CGRectMake(boundsX+70, 5, 200, 25);
    secondaryLabel.frame = CGRectMake(boundsX+70, 30, 100, 15);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

@end
