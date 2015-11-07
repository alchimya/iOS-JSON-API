# iOS-JSON-API
A very easy way to consume JSON API (ObjC and Swift)

#How to use

With the L3SDKJWARequest class (ObjC and Swift) you can consume JSON API in a very easy and light way.
You have just to send a request by using the static method sendTo of the L3SDKJWARequest calss
<br/>
```objectivec
+(void)sendTo:(NSString*)url
   withMethod:(HTTPRequestMethod)httpMethod
    andParams:(NSDictionary*)params
  andDelegate:(id<L3SDKJWARequestDelegate>)delegate;
```
where
 - <b>url</b>: is the url wher you want to send the request, for instance https://api.github.com/users/alchimya/repos
 - <b>httpMethod</b>: allows to define if you are sending a GET or a POST
 - <b>params</b>: put here the http body as a dictionary key (param name) and value
 - <b>delegate</b>: pass here you delegate class to receive the callbacks


Here as example a code snippet

```objectivec
[L3SDKJWARequest 
	sendTo:@"https://api.github.com/users/alchimya/repos"
        withMethod:HTTPRequestMethodGet
        andParams:nil andDelegate:self
];

-(void)L3SDKJWARequestDelegate_Response:(id)response{
	//put here your code
	
	//Note: response could be and array or a drictionary

	 if ([response isKindOfClass:[NSDictionary class]]) {
        NSLog(@"jsons response has a dictionary format");
        
    }else if ([response isKindOfClass:[NSArray class]]) {
    	 NSLog(@"jsons response has an array format");
    }
}

-(void)L3SDKJWARequestDelegate_Error:(NSError*)error{
	// put here your code
    NSLog(@"%@",[error localizedDescription]);
}

```

<h5>methods</h5>
  name                    |     type        |   description    
--------------------------| ----------------|-------------------------------------------------------------------
sendTo        			  | void            | static method used to send a request to the service



<h5>protocols</h5>

```objectivec
//protocol to describe the response events
@protocol L3SDKJWARequestDelegate <NSObject>
//raised when a response will be sent from the service
-(void)L3SDKJWARequestDelegate_Response:(id)response;
@optional
//raised if occur an error
-(void)L3SDKJWARequestDelegate_Error:(NSError*)error;
@end
```

```objectivec
<h5>enum</h5>
//enumeration to describe the http verbs
typedef enum : NSUInteger {
    HTTPRequestMethodGet,
    HTTPRequestMethodPost
} HTTPRequestMethod;

```
<br/>
![ScreenShot](https://raw.github.com/alchimya/iOS-JSON-API/master/screenshots/iOS-JSON-API.gif)
