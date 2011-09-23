//
//  REHttpDelegate.h
//  iaptest01
//
//  Created by administrator on 22/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <libxml2/libxml/parser.h>
#include <libxml2/libxml/xmlmemory.h>
#include <libxml2/libxml/tree.h>
#include <libxml2/libxml/xpath.h>

@protocol REHttpDelegateCallback;

@interface REHttpDelegate : NSObject {
    NSMutableData * response;
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;


@property(nonatomic, copy, readwrite) NSString* action;
@property(nonatomic, assign) id <REHttpDelegateCallback> delegate;


@end


@protocol REHttpDelegateCallback <NSObject>

@required
- (void) onHttpComplete:(REHttpDelegate*)http_delegate withResponse:(NSData*)response;

@end

@interface RERoarResponse : NSObject
{
    xmlParserCtxt * xml_parser_context;
    xmlDoc * xml_doc;
    NSString * controller_name;
    NSString * action_name;
}

- (id) initWithData:(NSData*)data forController:(NSString*)cn andAction:(NSString*)an;
- (void) dealloc;
- (NSString*) newStringFromXpath:(NSString*) xpath;
- (NSArray*) newArrayOfAttributeDictsFromXpath:(NSString*) xpath;
- (BOOL) xpathExists:(NSString*) xpath;
- (BOOL) isOK:(NSMutableString*)error_message;

@end