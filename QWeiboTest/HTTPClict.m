//
//  HTTPClict.m
//  QWeiboTest
//
//  Created by 张国涛 on 12-10-10.
//  Copyright (c) 2012年 张国涛. All rights reserved.
//
#define BASEURL @"https://open.t.qq.com/api/t/add"

#define SINAOUATHURL @"https://api.weibo.com/oauth2/access_token"

#define SINAURL @"https://api.weibo.com/2/statuses/update.json"

#define APPKEY  @"801193272"

#import "HTTPClict.h"
#import "AFNetworking.h"

@implementation HTTPClict

+ (HTTPClict *)shareCliect:(NSString*)type
{
    static HTTPClict *_shareInstance = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        if ([type isEqualToString:@"tecent"]) {
            _shareInstance = [[HTTPClict alloc] initWithBaseURL:
                              [NSURL URLWithString:BASEURL]];
        } else if ([type isEqualToString:@"sinaOuath"]){
            _shareInstance = [[HTTPClict alloc] initWithBaseURL:
                              [NSURL URLWithString:SINAOUATHURL]];
        } else if ([type isEqualToString:@"sina"]) {
            _shareInstance = [[HTTPClict alloc] initWithBaseURL:
                              [NSURL URLWithString:SINAURL]];
        }
    });
    return _shareInstance;
}

- (id)initWithBaseURL:(NSURL *)url
{
    if ((self = [super initWithBaseURL:url])) {
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"*/*"];        
    }
    return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *request = [super requestWithMethod:@"POST"
													   path:path
												 parameters:parameters];
    NSLog(@"request is %@",request);
	/* 30 seconds time out */
	[request setTimeoutInterval:30.0f];
	return request;
}


@end
