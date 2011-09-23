//
//  REUtils.h
//  iaptest01
//
//  Created by administrator on 22/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface REUtils : NSObject 
{
}

+ (NSString*) urlEncodeStringValue:(NSString*)value;
+ (NSString*) hexEncodeData:(NSData*)data;

@end
