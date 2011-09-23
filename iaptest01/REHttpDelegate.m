//
//  REHttpDelegate.m
//  iaptest01
//
//  Created by administrator on 22/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "REHttpDelegate.h"




@implementation REHttpDelegate

@synthesize action;
@synthesize delegate;

-(id) init
{
    if((self=[super init]))
    {
        response = [[NSMutableData alloc] init];
    }
    return self;
}

-(void) dealloc
{
    [response release];
    [super dealloc];
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)server_response
{
    NSLog(@"RERoarEngine::connection didReceiveResponse %@", server_response);
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data
{
    NSLog(@"RERoarEngine::connection didReceiveData: %@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
    [response appendData:data];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error
{
    NSLog(@"RERoarEngine::didFailWithError: %@", error); 
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"RERoarEngine::connectionDidFinishLoading");
    [delegate onHttpComplete:self withResponse:self->response];
 //   [self release]; //TODO: Adding this crashes the app :(

}

@end

@implementation RERoarResponse

- (id) initWithData:(NSData*)data forController:(NSString*)cn andAction:(NSString*)an
{
    if ((self = [super init]))
    {
        xml_parser_context = xmlNewParserCtxt(); 
        xml_doc  = xmlCtxtReadMemory(
                          xml_parser_context, 
                          [data bytes],
                          [data length],
                          "",
                          NULL,
                          XML_PARSE_NONET );
        if( ! xml_doc )
        {
            NSLog(@"Error parsing XML: %s", xml_parser_context->lastError.message);
            [self release];
            return nil;
        }
        
        xmlNode * cur = xmlDocGetRootElement(xml_doc);
        if( ! cur )
        {
            [self release];
            return nil;
        }
        
        controller_name = cn;
        [controller_name retain];
        action_name = an;
        [action_name retain];
        
        NSLog(@"Root element is %s", cur->name );
        
        xmlNode * child = cur->children;
        while(child)
        {
            if( child->type == XML_ELEMENT_NODE )
            {
                NSLog(@"Child element is %s", child->name );
                xmlNode * subchild = child->children;
                while(subchild)
                {
                    if (subchild->type == XML_ELEMENT_NODE )
                    {
                        NSLog(@"Subchild is %s", subchild->name);
                    }
                    subchild = subchild->next;
                }
            }
            child = child->next;
        }
    
    }
    return self;
}

- (void) dealloc
{
    xmlFreeDoc(xml_doc);
    xmlFreeParserCtxt(xml_parser_context);
    [controller_name release];
    [action_name release];
    [super dealloc];
}


- (BOOL) xpathExists:(NSString*) xpath 
{
    xmlXPathContext * xpathCtx = xmlXPathNewContext(xml_doc);
    NSAssert(xpathCtx,@"Unable to create xpath context");
    
    xmlXPathObject * xpathObj = xmlXPathEvalExpression((const xmlChar*) [xpath UTF8String], xpathCtx);
    NSAssert(xpathObj,@"Invalid xpath");
    
 
    BOOL retval = xpathObj->nodesetval && xpathObj->nodesetval->nodeNr>0;
    
    xmlXPathFreeObject(xpathObj);
    xmlXPathFreeContext(xpathCtx);
    
    return retval;
}

- (NSString*) newStringFromXpath:(NSString*) xpath
{
    xmlXPathContext * xpathCtx = xmlXPathNewContext(xml_doc);
    NSAssert(xpathCtx,@"Unable to create xpath context");
    
    xmlXPathObject * xpathObj = xmlXPathEvalExpression((const xmlChar*) [xpath UTF8String], xpathCtx);
    NSAssert(xpathObj,@"Invalid xpath");
    
    
    NSAssert( xpathObj->nodesetval && xpathObj->nodesetval->nodeNr==1, @"Expected exactly one value in the xpath");
    
    NSString * retval = [[NSString alloc] initWithUTF8String:(char*)xpathObj->nodesetval->nodeTab[0]->content];
    xmlXPathFreeObject(xpathObj);
    xmlXPathFreeContext(xpathCtx);
    
    return retval;
}

//For xpaths like /foo/bar/
//Returns an NSArray of NSDictionary containing the attributes on the matching nodes

- (NSArray*) newArrayOfAttributeDictsFromXpath:(NSString*) xpath
{
    xmlXPathContext * xpathCtx = xmlXPathNewContext(xml_doc);
    NSAssert(xpathCtx,@"Unable to create xpath context");
    
    xmlXPathObject * xpathObj = xmlXPathEvalExpression((const xmlChar*) [xpath UTF8String], xpathCtx);
    NSAssert(xpathObj,@"Invalid xpath");
    
    NSMutableArray * retval = [[NSMutableArray alloc] init];
    if (xpathObj->nodesetval!=NULL)
    {
        for( int i=0; i<xpathObj->nodesetval->nodeNr; ++i)
        {
            NSMutableDictionary * attributes = [[NSMutableDictionary alloc] init];
            xmlAttr * xml_attr = xpathObj->nodesetval->nodeTab[i]->properties;
            while(xml_attr)
            {
                if(xml_attr->name && xml_attr->children && xml_attr->children->content)
                {
                    [attributes
                     setObject:[NSString stringWithUTF8String:(const char*)xml_attr->children->content]
                     forKey:[NSString stringWithUTF8String:(const char*)xml_attr->name] ];
                }
                xml_attr = xml_attr->next;
            }
            
            [retval addObject:attributes];
        }
    }

    xmlXPathFreeObject(xpathObj);
    xmlXPathFreeContext(xpathCtx);
    
    return retval;
}

- (BOOL) isOK:(NSMutableString*)error_message
{
    xmlNode * cur = xmlDocGetRootElement(xml_doc);
    if( ! cur )
    {
        [self release];
        [error_message setString:@"Invalid root node"]; 
        return NO;
    }
    
    NSString * xpath_ok = [[NSString alloc] initWithFormat:@"/roar/%@/%@[@status=\"ok\"]", controller_name, action_name];
    NSString * xpath_error = [[NSString alloc] initWithFormat:@"/roar/%@/%@[@status=\"error\"]/error/text()", controller_name, action_name];
    
    BOOL retval;
    if ( [self xpathExists:xpath_ok] )
    {
        retval = YES;
    }
    else
    {
        retval = NO;
        NSString * em = [self newStringFromXpath:xpath_error];
        if(em)
        {
            [error_message setString:em];
            [em release];
        }
        else
        {
            [error_message setString:@"No error entry found"];
        }
    }
    
    [xpath_ok release];
    [xpath_error release];
    
    return retval;
}

@end