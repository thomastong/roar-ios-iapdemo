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

@interface iaptest01AppDelegate : NSObject <UIApplicationDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver,
    RERoarEngineDelegate> {
    
    UIButton * login_button;
    UIButton * create_button;
    UITextField * username_field;
    UITextField * password_field;
    UITextField * auth_token_field;
        
    RERoarEngine * roar_engine;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIButton *login_button;
@property (nonatomic, retain) IBOutlet UIButton *create_button;
@property (nonatomic, retain) IBOutlet UITextField *username_field;
@property (nonatomic, retain) IBOutlet UITextField *password_field;
@property (nonatomic, retain) IBOutlet UITextField *auth_token_field;

- (IBAction) doLoginButton;
- (IBAction) doCreateButton;
- (void) requestProductData;
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;

@end