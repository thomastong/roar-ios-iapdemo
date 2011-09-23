//
//  IAPListViewController.h
//  iaptest01
//
//  Created by administrator on 23/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@protocol IAPListViewDelegate <NSObject>

@required
- (void) selectedIAPToView:(NSDictionary*)iap_info;
@end

@interface IAPListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SKProductsRequestDelegate>
{
    // This is intially filled by the setIAPList call, setting entries to an loading state
    // Then as we get info back from the appstore we fill in that extra information.
    NSMutableArray * iap_entries;
    NSMutableDictionary * iap_key_to_entry;
    UITableView * tableView;
    
    id <IAPListViewDelegate> delegate;
}

@property(nonatomic,retain) IBOutlet UITableView* tableView;

- (void) setDelegate:(id<IAPListViewDelegate>)d;
- (void) setIAPList:(NSArray*)iapl;
- (void) requestProductData;
@end
