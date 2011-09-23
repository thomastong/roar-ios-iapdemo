//
//  iaptest01AppDelegate.m
//  iaptest01
//
//  Created by administrator on 21/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iaptest01AppDelegate.h"
#import "REUtils.h"




@implementation iaptest01AppDelegate


@synthesize window=_window;
@synthesize login_button, create_button, username_field, password_field, auth_token_field;
@synthesize login_view;
@synthesize main_view;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    roar_engine = [[RERoarEngine alloc] init];
    roar_engine.delegate = self;
    
    // Override point for customization after application launch.
    [application setStatusBarHidden:YES];
    
    iap_list_view_controller = [[IAPListViewController alloc] initWithNibName:@"IAPListViewController" bundle:nil];
    [iap_list_view_controller setDelegate:self];
    
    iap_detail_view_controller = [[IAPDetailViewController alloc] initWithNibName:@"IAPDetailViewController" bundle:nil];
    
    
    [self.window makeKeyAndVisible];
    [self.window addSubview:self.login_view];
    
    if( [SKPaymentQueue canMakePayments] )
    {
        NSLog(@"Payments are OK");
        //[self requestProductData];
    }
    else
    {
        NSLog(@"Payments are not OK");
    }
    
    return YES;
}


- (void)dealloc
{
    [_window release];
    [roar_engine release];
    [iap_list_view_controller release];
    [iap_detail_view_controller release];
    [super dealloc];
}

- (IBAction) doLoginButton
{
    NSLog(@"Login Button Clicked");
    NSLog(@"username : %@", [username_field text]);
    NSLog(@"password : %@", [password_field text]);
    [roar_engine login:[username_field text] withPassword:[password_field text]];
}

- (IBAction) doCreateButton
{
    NSLog(@"Create Button Clicked");
    NSLog(@"username : %@", [username_field text]);
    NSLog(@"password : %@", [password_field text]);
    [roar_engine create:[username_field text] withPassword:[password_field text]];
}

- (IBAction) doGetIAPList
{
    [roar_engine get_iap_list:[auth_token_field text]];
}

- (void) onLogin:(RERoarEngine *)engine withAuthToken:(NSString *)auth_token
{
    [auth_token_field setText:auth_token];
    [self.window addSubview:self.main_view];
    NSLog(@"iaptest::onLogin %@", auth_token);
}

- (void) onCreate:(RERoarEngine *)engine
{
    NSLog(@"iaptest::onCreate");
}

- (void) onIAPList:(RERoarEngine *)engine values:(NSArray *)iapList
{
    NSLog(@"Got %d items in IAP list", [iapList count]);
    NSLog(@"%@", iapList);
    [iap_list_view_controller setIAPList:iapList];
    [self.window addSubview:iap_list_view_controller.view];
}

- (void) selectedIAPToView:(NSDictionary*)iap_info
{
    NSLog(@"You clicked %@!", [iap_info objectForKey:@"product_identifier"]);
    NSLog(@"%@", iap_info);
    [iap_detail_view_controller setInfo:iap_info];
    [self.window addSubview:iap_detail_view_controller.view];
}



- (void) requestProductData
{
    SKProductsRequest *request= [[SKProductsRequest alloc]
                                 initWithProductIdentifiers: [NSSet setWithObjects: 
                                                                @"com.roarengine.iaptest01.consumable01", 
                                                                @"com.roarengine.iaptest01.nonexistant",
                                                                nil] ];
    request.delegate = self;
    [request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:
(SKProductsResponse *)response
{
    NSArray *myProduct = response.products;

    for( SKProduct * r in myProduct )
    {
        NSLog(@"  Title       : %@\n", r.localizedTitle );
        NSLog(@"  Description : %@\n", r.localizedDescription );
        
        //Lets format the price as nicely as we can.
        NSNumberFormatter * currencyFormatter = [[[NSNumberFormatter alloc] init] autorelease];
        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [currencyFormatter setLocale:r.priceLocale];
        
        NSLog(@"  Price       : %@ %@\n", [currencyFormatter stringFromNumber:r.price], [currencyFormatter internationalCurrencySymbol] );
        NSLog(@"  Identifier  : %@\n", r.productIdentifier );
    }
    NSLog(@"invalid ids: %@\n", response.invalidProductIdentifiers );
    
    // populate UI
    
    //Lets try buy one :)
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self ];
    
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"com.roarengine.iaptest01.consumable01"];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
    [request autorelease];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"Purchase OK: %@", transaction.transactionIdentifier);
                NSString * recpt = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
                NSLog(@"    Receipt: %@", recpt);
                [recpt release];
                NSLog(@"  ReceiptHex: %@", [REUtils hexEncodeData:transaction.transactionReceipt]);
                

//                [self completeTransaction:transaction];
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"Purchase Failed: %@", transaction.error);
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
//                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
//                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

/*
- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    // Your application should implement these two methods.
    [self recordTransaction: transaction];
    [self provideContent: transaction.payment.productIdentifier];
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // Optionally, display an error here.
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
*/

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


@end
