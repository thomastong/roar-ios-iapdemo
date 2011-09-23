//
//  RERoarEngine.h
//  iaptest01
//
//  Created by administrator on 22/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "REHttpDelegate.h"

@protocol RERoarEngineDelegate;

@interface RERoarEngine : NSObject <REHttpDelegateCallback>
{
}

- (void)login:(NSString *)username withPassword:(NSString *)password;
- (void)create:(NSString *)username withPassword:(NSString *)password;
- (void)get_iap_list:(NSString*)auth_token;

- (void) onHttpComplete:(REHttpDelegate*)http_delegate withResponse:(NSData*)response;

@property(nonatomic, assign) id <RERoarEngineDelegate> delegate;

@end


@protocol RERoarEngineDelegate <NSObject>

@required
- (void) onLogin:(RERoarEngine*)engine withAuthToken:(NSString*)auth_token;
- (void) onCreate:(RERoarEngine*)engine;
- (void) onIAPList:(RERoarEngine*)engine values:(NSArray*)iapList;
@end
