//
//  IPAListCell.h
//  iaptest01
//
//  Created by administrator on 23/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IAPListCell : UITableViewCell {
    UILabel * primaryLabel;
    UILabel * secondaryLabel;
    UIImageView * imageView;
}

@property(nonatomic,retain)UILabel* primaryLabel;
@property(nonatomic,retain)UILabel* secondaryLabel;
@property(nonatomic,retain)UIImageView * imageView;

@end
