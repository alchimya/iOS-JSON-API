//
//  JWARequest.m
//  ObjC-JSON-API
//
//  Created by Domenico Vacchiano on 07/11/15.
//  Copyright © 2015 DomenicoVacchiano. All rights reserved.
//

#import "L3SDKJWARequest.h"

@interface L3SDKJWARequest ()
+(NSString*)httpRequestMethodToString:(HTTPRequestMethod)httpRequestMethod;
@end


@implementation L3SDKJWARequest

+(void)sendTo:(NSString*)url
   withMethod:(HTTPRequestMethod)httpMethod
    andParams:(NSDictionary*)params
  andDelegate:(id<L3SDKJWARequestDelegate>)delegate{
    

    //creates and setup a request
    NSMutableURLRequest*request=[[NSMutableURLRequest alloc]
                                 initWithURL:[NSURL URLWithString:url]
                                 ];
    
    NSURLSession*session=[NSURLSession sharedSession];
    request.HTTPMethod=[self httpRequestMethodToString:httpMethod];
    if (params) {
        NSError *parseError = nil;
        request.HTTPBody=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&parseError];
        if (parseError) {
            if ([delegate respondsToSelector:@selector(L3SDKJWARequestDelegate_Error:)]) {
                [delegate L3SDKJWARequestDelegate_Error:parseError];
            }
            return;
        }
    }
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //sends a request to consume a service
    [[session dataTaskWithRequest:request completionHandler: ^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable taskError){
        if (taskError) {
            if ([delegate respondsToSelector:@selector(L3SDKJWARequestDelegate_Error:)]) {
                [delegate L3SDKJWARequestDelegate_Error:taskError];
            }
            return;
        }
        NSError *parseError = nil;
        id json=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&parseError];
        if (parseError) {
            if ([delegate respondsToSelector:@selector(L3SDKJWARequestDelegate_Error:)]) {
                [delegate L3SDKJWARequestDelegate_Error:parseError];
            }
        }else{
            if ([delegate respondsToSelector:@selector(L3SDKJWARequestDelegate_Response:)]) {
                [delegate L3SDKJWARequestDelegate_Response:json];
            }
        }
    }]resume];
  
}
+(NSString*)httpRequestMethodToString:(HTTPRequestMethod)httpRequestMethod{
    
    //convert an enum member to a string http verb
    switch (httpRequestMethod) {
        case HTTPRequestMethodGet:
            return @"GET";
        case HTTPRequestMethodPost:
            return @"POST";
        default:
            return @"GET";
            break;
    }
}
@end
