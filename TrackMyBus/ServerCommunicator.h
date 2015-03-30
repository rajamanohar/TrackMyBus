//
//  ServerCommunicator.h
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/19/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ServerCommunicatorDelegate;

@interface ServerCommunicator : NSObject

typedef void (^Success)(NSDictionary *responseDict);
typedef void (^Error)(NSError *error);

-(void)requestWithQuery:(NSString *)queryString;
@property (nonatomic, assign) id <ServerCommunicatorDelegate> delegate;

@end

@protocol ServerCommunicatorDelegate

- (void)didDownloadComplete:(NSArray *)responseData;

@end
