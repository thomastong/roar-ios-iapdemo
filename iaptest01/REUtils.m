//
//  REUtils.m
//  iaptest01
//
//  Created by administrator on 22/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "REUtils.h"

static const char hexEncodingTable[] = "0123456789ABCDEF";

@implementation REUtils

+ (NSString *)hexEncodeData:(NSData *)data;
{
	if ([data length] == 0)
		return @"";
    
    char *characters = malloc([data length] * 2);
	if (characters == NULL)
		return nil;
    for( NSUInteger i =0; i< [data length] ; ++i)
	{
        unsigned char c = ((unsigned char*)[data bytes])[i];
        characters[2*i]=hexEncodingTable[ c & 0x0F];
        characters[2*i+1]=hexEncodingTable[ (c & 0xF0) >> 4 ];
	}
	
	return [[[NSString alloc] initWithBytesNoCopy:characters length:[data length]*2 encoding:NSASCIIStringEncoding freeWhenDone:YES] autorelease];
}

+ (NSString *) urlEncodeStringValue:(NSString *)value
{
    NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)value, NULL, CFSTR("?=&+"), kCFStringEncodingUTF8);
    return [result autorelease];
}

@end
