//
//  IAPDetailViewController.m
//  iaptest01
//
//  Created by administrator on 23/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IAPDetailViewController.h"
#import "iaptest01AppDelegate.h"


@implementation IAPDetailViewController

@synthesize iap_info = iap_info_;
@synthesize product_description_label;
@synthesize roar_description_label;
@synthesize appstore_title_label;
@synthesize appstore_description_label;
@synthesize appstore_price_label;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


- (void) setInfo:(NSDictionary *)iap_info
{
    self.iap_info = iap_info;
    NSDictionary * roar_info = [iap_info objectForKey:@"roar_info"];
    [self.product_description_label setText:[roar_info objectForKey:@"product_identifier"]];
    [self.roar_description_label setText:[roar_info objectForKey:@"label"]];
    
    SKProduct * p = [iap_info objectForKey:@"appstore_info"];
    
    [self.appstore_title_label setText:p.localizedTitle];
    [self.appstore_description_label setText:p.localizedDescription];
    
    //Lets format the price as nicely as we can.
    NSNumberFormatter * currencyFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyFormatter setLocale:p.priceLocale];
    
    [self.appstore_price_label setText:[NSString stringWithFormat:@"%@ [%@]", [currencyFormatter stringFromNumber:p.price], [currencyFormatter internationalCurrencySymbol] ] ];
}

- (void) setAppDelegate:(iaptest01AppDelegate*) app_delegate
{
    app_delegate_ = app_delegate;
}

- (IBAction)buyClicked
{
    NSDictionary * roar_info = [self.iap_info objectForKey:@"roar_info"];
    [app_delegate_ buySomething:[roar_info objectForKey:@"product_identifier"]];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
