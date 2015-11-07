//
//  L3SDKJWARequest.h
//  ObjC-JSON-API
//
//  Created by Domenico Vacchiano on 07/11/15.
//  Copyright © 2015 DomenicoVacchiano. All rights reserved.
//

#import <Foundation/Foundation.h>

//protocol to describe the response events
@protocol L3SDKJWARequestDelegate <NSObject>
//raised when a response will be sent from the service
-(void)L3SDKJWARequestDelegate_Response:(id)response;
@optional
//raised if occur an error
-(void)L3SDKJWARequestDelegate_Error:(NSError*)error;
@end

//enumeration to describe the http verbs
typedef enum : NSUInteger {
    HTTPRequestMethodGet,
    HTTPRequestMethodPost
} HTTPRequestMethod;

@interface L3SDKJWARequest : NSObject

//method used to send a request to the service
+(void)sendTo:(NSString*)url
   withMethod:(HTTPRequestMethod)httpMethod
    andParams:(NSDictionary*)params
  andDelegate:(id<L3SDKJWARequestDelegate>)delegate;

@end
