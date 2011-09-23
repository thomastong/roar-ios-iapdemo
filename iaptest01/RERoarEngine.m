//
//  RERoarEngine.m
//  iaptest01
//
//  Created by administrator on 22/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RERoarEngine.h"
#import "REUtils.h"
#import "REHttpDelegate.h"

#include <libxml2/libxml/parser.h>
#include <libxml2/libxml/xmlmemory.h>
#include <libxml2/libxml/tree.h>
#include <libxml2/libxml/xpath.h>

@implementation RERoarEngine

@synthesize delegate;


- (void) login:(NSString *)username withPassword:(NSString *)password
{
    NSURL * the_url = [NSURL URLWithString:@"http://192.168.1.2/server/user/login/"];
    NSMutableURLRequest * theRequest=[NSMutableURLRequest requestWithURL:the_url ];
    [theRequest setHTTPMethod:@"POST"];
    NSString * postString =[NSString stringWithFormat:@"name=%@&hash=%@", [REUtils urlEncodeStringValue:username], [REUtils urlEncodeStringValue:password]];
    [theRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    REHttpDelegate * http_delegate = [[REHttpDelegate alloc] init];
    http_delegate.action = @"login";
    http_delegate.delegate = self;
    
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:http_delegate];
    [http_delegate release];
}

- (void) create:(NSString *)username withPassword:(NSString *)password
{
    NSMutableURLRequest * theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.2/server/user/create/"] ];
    [theRequest setHTTPMethod:@"POST"];
    NSString * postString =[NSString stringWithFormat:@"name=%@&hash=%@", [REUtils urlEncodeStringValue:username], [REUtils urlEncodeStringValue:password]];
    [theRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    REHttpDelegate * http_delegate = [[REHttpDelegate alloc] init];
    http_delegate.action = @"create";
    http_delegate.delegate = self;
    
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:http_delegate];
   [http_delegate release];
}



- (void) onHttpComplete:(REHttpDelegate*)http_delegate withResponse:(NSData*)response
{
    
    if( [http_delegate.action isEqualToString:@"create"] )
    {
        RERoarResponse * rr = [[RERoarResponse alloc] initWithData:response forController:@"user" andAction:@"create"];
        NSMutableString * error_message = [[NSMutableString alloc] init];
        if( ! [rr isOK:error_message] )
        {
            NSLog(@"Failure in create : %@", error_message);
        }
        else
        {
            [self.delegate onCreate:self];
        }
        [rr release];
    }
    else if( [http_delegate.action isEqualToString:@"login"] )
    {
        RERoarResponse * rr = [[RERoarResponse alloc] initWithData:response forController:@"user" andAction:@"login"];
        NSMutableString * error_message = [[NSMutableString alloc] init];
        if( ! [rr isOK:error_message] )
        {
            NSLog(@"Failure in create : %@", error_message);
        }
        else
        {
            NSString * authToken = [rr newStringFromXpath:@"/roar/user/login/auth_token/text()"];
            [self.delegate onLogin:self withAuthToken:authToken];
        }
        [rr release];
    }
    
  /*  
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ROAR Error" message:@"Some error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil ];
    [alert show];
    [alert release];
 */


    
    
}

@end
