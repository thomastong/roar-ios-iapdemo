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

- (void) appstore_purchase:(SKPaymentTransaction *)transaction withAuthToken:(NSString *)auth_token
{
    NSLog(@"auth token: %@", auth_token);
    NSLog(@"Purchase OK: %@", transaction.transactionIdentifier);
    NSString * recpt = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
    NSLog(@"    Receipt: %@", recpt);
    [recpt release];
    NSLog(@"  ReceiptHex: %@", [REUtils hexEncodeData:transaction.transactionReceipt]);
    
    NSMutableURLRequest * theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.2/server/appstore/buy/"] ];
    [theRequest setHTTPMethod:@"POST"];
    NSString * postString =[NSString stringWithFormat:@"auth_token=%@&sandbox=1&receipt=%@", [REUtils urlEncodeStringValue:auth_token], [REUtils urlEncodeStringValue:[REUtils hexEncodeData:transaction.transactionReceipt]]];
    [theRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    REHttpDelegate * http_delegate = [[REHttpDelegate alloc] init];
    http_delegate.action = @"buy_iap";
    http_delegate.delegate = self;
    
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:http_delegate];
    [http_delegate release];
}

- (void) get_iap_list:(NSString *)auth_token
{
    NSMutableURLRequest * theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.2/server/appstore/shop_list/"] ];
    [theRequest setHTTPMethod:@"POST"];
    NSString * postString =[NSString stringWithFormat:@"auth_token=%@", [REUtils urlEncodeStringValue:auth_token] ];
    [theRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    REHttpDelegate * http_delegate = [[REHttpDelegate alloc] init];
    http_delegate.action = @"get_iap_list";
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
            //This should probably be in an error handler .. but it'll do in here for now.
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ROAR Create Error" message:[NSString stringWithFormat:@"Failure in create : %@", error_message] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil ];
            [alert show];
            [alert release];
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
            NSLog(@"Failure in login : %@", error_message);
            //This should probably be in an error handler .. but it'll do in here for now.
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ROAR Login Error" message:[NSString stringWithFormat:@"Failure in login : %@", error_message] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil ];
            [alert show];
            [alert release];
        }
        else
        {
            NSString * authToken = [rr newStringFromXpath:@"/roar/user/login/auth_token/text()"];
            [self.delegate onLogin:self withAuthToken:authToken];
        }
        [rr release];
    }

    else if( [http_delegate.action isEqualToString:@"get_iap_list"] )
    {
        RERoarResponse * rr = [[RERoarResponse alloc] initWithData:response forController:@"appstore" andAction:@"shop_list"];
        NSMutableString * error_message = [[NSMutableString alloc] init];
        if( ! [rr isOK:error_message] )
        {
            NSLog(@"Failure in appstore/shop_list : %@", error_message);
            //This should probably be in an error handler .. but it'll do in here for now.
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ROAR IAP List Error" message:[NSString stringWithFormat:@"Failure in appstore/shop_list : %@", error_message] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil ];
            [alert show];
            [alert release];
        }
        else
        {
             NSArray * iap_list = [rr newArrayOfAttributeDictsFromXpath:@"/roar/appstore/shop_list/shopitem"];
             [self.delegate onIAPList:self values:iap_list];
             [iap_list release];
        }
        [rr release];
    }
    else if( [http_delegate.action isEqualToString:@"buy_iap"] )
    {
        RERoarResponse * rr = [[RERoarResponse alloc] initWithData:response forController:@"appstore" andAction:@"buy"];
        NSMutableString * error_message = [[NSMutableString alloc] init];
        if( ! [rr isOK:error_message] )
        {
            NSLog(@"Failure in appstore/buy : %@", error_message);
            //This should probably be in an error handler .. but it'll do in here for now.
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ROAR IAP Buy Error" message:[NSString stringWithFormat:@"Failure in appstore/buy : %@", error_message] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil ];
            [alert show];
            [alert release];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ROAR IAP Buy OK" message:@"Buy was OK" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil ];
            [alert show];
            [alert release];
        }
        [rr release];
    }
}

@end
