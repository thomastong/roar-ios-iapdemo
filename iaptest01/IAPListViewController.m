//
//  IAPListViewController.m
//  iaptest01
//
//  Created by administrator on 23/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IAPListViewController.h"
#import "IAPListCell.h"


@implementation IAPListViewController

@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        iap_entries = nil;
        iap_key_to_entry = nil;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [iap_entries release];
    [iap_key_to_entry release];
}

- (void) setIAPList:(NSArray*)iapl
{
    [iap_entries release];
    iap_entries = [[NSMutableArray alloc] init];
    
    [iap_key_to_entry release];
    iap_key_to_entry = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary * d in iapl)
    {
        NSMutableDictionary * dd = [[NSMutableDictionary alloc] init];
        [iap_entries addObject:dd];
        [dd setObject:d forKey:@"roar_info"];
        [dd setObject:@"loading" forKey:@"state"];
        [iap_key_to_entry setObject:dd forKey:[d objectForKey:@"product_identifier"]];
    }
    
    [self requestProductData];
}

- (void) setDelegate:(id<IAPListViewDelegate>)d
{
    delegate = d;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [iap_entries count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"iapCell";
    IAPListCell * cell = (IAPListCell*)[tv dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[IAPListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NSDictionary * d = [iap_entries objectAtIndex:indexPath.row];
    
    NSDictionary * roar_info = [d objectForKey:@"roar_info"];
    cell.primaryLabel.text = [roar_info objectForKey:@"label"];
    cell.secondaryLabel.text = [roar_info objectForKey:@"product_identifier"];
    
    NSString * state = [d objectForKey:@"state"];
    if( [state isEqualToString:@"loading"] )
    {
        cell.imageView.image = [UIImage imageNamed:@"unknown01.png"];
        cell.imageView.animationImages = [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"unknown01.png"],
                                     [UIImage imageNamed:@"unknown02.png"],
                                    [UIImage imageNamed:@"unknown03.png"],
                                    [UIImage imageNamed:@"unknown04.png"],
                                    [UIImage imageNamed:@"unknown05.png"],
                                    [UIImage imageNamed:@"unknown06.png"],
                                    [UIImage imageNamed:@"unknown07.png"],
                                     nil];
        cell.imageView.animationDuration=1.5;
        [cell.imageView startAnimating];
    }
    else if( [state isEqualToString:@"ok"] )
    {
        cell.imageView.image = [UIImage imageNamed:@"ok.png"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"failed.png"];
    }
    
    return cell;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"In App Purchases";
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [delegate selectedIAPToView:[iap_entries objectAtIndex:indexPath.row] ];
}



- (void) requestProductData
{
    NSMutableSet * identifiers = [[NSMutableSet alloc] init];
    
    for (NSDictionary * d in iap_entries)
    {
        [identifiers addObject:[[d objectForKey:@"roar_info"] objectForKey:@"product_identifier"]];
    }
    
    SKProductsRequest *request= [[SKProductsRequest alloc]
                                 initWithProductIdentifiers: [NSSet setWithSet:identifiers] ];
    
    request.delegate = self;
    [request start];
    [identifiers release];
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
        
        NSMutableDictionary * d = [iap_key_to_entry objectForKey:r.productIdentifier];

        [d setObject:@"ok" forKey:@"state"];
        [d setObject:r forKey:@"appstore_info"];
        NSLog(@" d = %@", d);
        
    }
    
    NSLog(@"invalid ids: %@\n", response.invalidProductIdentifiers );
    for ( NSString * k in response.invalidProductIdentifiers)
    {
        NSMutableDictionary * d = [iap_key_to_entry objectForKey:k];
        [d setObject:@"failed" forKey:@"state"];
        NSLog(@" d = %@", d);
    }
    
    //Force a UI update
    [tableView reloadData];
    
    
    // populate UI (again?)
    
    //Lets try buy one :)
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self ];
//    
//    SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"com.roarengine.iaptest01.consumable01"];
//    [[SKPaymentQueue defaultQueue] addPayment:payment];
//    
//    [request autorelease];
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
