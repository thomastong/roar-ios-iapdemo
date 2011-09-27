//
//  InfoViewController.m
//  iaptest01
//
//  Created by administrator on 27/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"
#import "iaptest01AppDelegate.h"


@implementation InfoViewController

@synthesize server_root;

- (id)initWithNibName:(NSString *)nibNameOrNil app:(iaptest01AppDelegate*)app bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        app_ = app;
        [server_root setText:app_.roar_engine.server_root];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (IBAction) onDone
{
    app_.roar_engine.server_root = [server_root text];
    [server_root resignFirstResponder];
    [app_.window addSubview:app_.login_view];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [server_root setText:app_.roar_engine.server_root];
}

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
