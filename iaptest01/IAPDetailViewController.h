//
//  IAPDetailViewController.h
//  iaptest01
//
//  Created by administrator on 23/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IAPDetailViewController : UIViewController
{
    NSDictionary * iap_info_;
    
}

@property (nonatomic, retain) NSDictionary *iap_info;

- (void) setInfo:(NSDictionary*) iap_info;

@end
