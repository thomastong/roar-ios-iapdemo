//
//  IAPDetailViewController.h
//  iaptest01
//
//  Created by administrator on 23/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class iaptest01AppDelegate;


@interface IAPDetailViewController : UIViewController
{
    UILabel * product_identifier_label;
    UILabel * roar_description_label;
   
    UILabel * appstore_title_label;
    UILabel * appstore_description_label;
    UILabel * appstore_price_label;
    
    NSDictionary * iap_info_;
    iaptest01AppDelegate * app_delegate_;
    
}

@property (nonatomic, retain) NSDictionary *iap_info;
@property (nonatomic, retain) IBOutlet UILabel* product_description_label;
@property (nonatomic, retain) IBOutlet UILabel* roar_description_label;

@property (nonatomic, retain) IBOutlet UILabel* appstore_title_label;
@property (nonatomic, retain) IBOutlet UILabel* appstore_description_label;
@property (nonatomic, retain) IBOutlet UILabel* appstore_price_label;

- (void) setAppDelegate:(iaptest01AppDelegate*) app_delegate;
- (void) setInfo:(NSDictionary*) iap_info;
- (IBAction) buyClicked;
@end
