//
//  iaptest01AppDelegate.h
//  iaptest01
//
//  Created by administrator on 21/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

#import "RERoarEngine.h"
#import "IAPListViewController.h"
#import "IAPDetailViewController.h"

@interface iaptest01AppDelegate : NSObject <UIApplicationDelegate, SKPaymentTransactionObserver,
    RERoarEngineDelegate,
    IAPListViewDelegate>
{
    
    UIButton * login_button;
    UIButton * create_button;
    UITextField * username_field;
    UITextField * password_field;
    UITextField * auth_token_field;
        
    UIView * login_view;
    UIView * main_view;
        
    RERoarEngine * roar_engine;
    IAPListViewController * iap_list_view_controller;
    IAPDetailViewController * iap_detail_view_controller;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIButton *login_button;
@property (nonatomic, retain) IBOutlet UIButton *create_button;
@property (nonatomic, retain) IBOutlet UITextField *username_field;
@property (nonatomic, retain) IBOutlet UITextField *password_field;
@property (nonatomic, retain) IBOutlet UITextField *auth_token_field;
@property (nonatomic, retain) IBOutlet UIView *login_view;
@property (nonatomic, retain) IBOutlet UIView *main_view;

- (IBAction) doLoginButton;
- (IBAction) doCreateButton;
- (IBAction) doGetIAPList;
- (void)buySomething:(NSString *)thing_to_buy;
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;

@end