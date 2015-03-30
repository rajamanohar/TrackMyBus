//
//  ServerCommunicator.m
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/19/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import "ServerCommunicator.h"
#import <UIKit/UIKit.h>

NSString* const MONAppsBaseUrl = @"http://localhost:3000/get?namedQuery=1abcd";

@interface ServerCommunicator ()<NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (nonatomic, strong) Success successHandler;
@property (nonatomic, strong) Error errorHandler;
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation ServerCommunicator
@synthesize delegate;

-(void)requestWithQuery:(NSString *)queryString
{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:queryString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
        [request setHTTPShouldHandleCookies:YES];
        [request setHTTPMethod:@"GET"];
    
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        NSLog(@"Starting connection: %@ for request: %@", connection, request);
}

#pragma mark - NSUrlConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
        if(!_responseData) {
            _responseData = [NSMutableData dataWithData:data];
        } else {
            [_responseData appendData:data];
        }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
        id object = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingAllowFragments error:nil];
        
        NSArray *arrResponse=[object objectForKey:@"response"];
        [self.delegate didDownloadComplete:arrResponse];
        //    if(_successHandler) {
        //        _successHandler(object);
        //    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
        if(_errorHandler) {
            _errorHandler(error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}

@end
