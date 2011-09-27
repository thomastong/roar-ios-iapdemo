//
//  InfoViewController.h
//  iaptest01
//
//  Created by administrator on 27/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iaptest01AppDelegate;

@interface InfoViewController : UIViewController {
    iaptest01AppDelegate* app_;
    UITextField * server_root;
}

- (id)initWithNibName:(NSString *)nibNameOrNil app:(iaptest01AppDelegate*)app bundle:(NSBundle *)nibBundleOrNil; 
- (IBAction) onDone;
@property (nonatomic, retain) IBOutlet UITextField* server_root;

@end
