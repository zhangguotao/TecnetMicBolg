//
//  HTTPClict.m
//  QWeiboTest
//
//  Created by 张国涛 on 12-10-10.
//  Copyright (c) 2012年 张国涛. All rights reserved.
//
#define BASEURL @"https://open.t.qq.com/api/t/add"
#define APPKEY  @"801193272"
#define ACCESS_TOKEN @"216358109659f07936e1ba47f3e37bd7"
#define OPEN_ID @"C4E977D616F12550D6DF1DF3D554EBEA"


#import "HTTPClict.h"
#import "AFNetworking.h"

@implementation HTTPClict

+ (HTTPClict *)shareCliect
{
    static HTTPClict *_shareInstance = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[HTTPClict alloc] initWithBaseURL:
                          [NSURL URLWithString:BASEURL]];
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
    
    if (parameters) {
        if ([method isEqualToString:@"GET"] || [method isEqualToString:@"POST"]){
            
			NSMutableDictionary *mutableParameters = [parameters mutableCopy];
			[mutableParameters setValue:@"801193272" forKey:@"oauth_consumer_key"];
			[mutableParameters setValue:@"123.108.212.196" forKey:@"clientip"];
			[mutableParameters setValue:@"2.a"       forKey:@"oauth_version"];
			[mutableParameters setValue:@"all"       forKey:@"scope"];
			parameters = [NSDictionary dictionaryWithDictionary:mutableParameters];
			[mutableParameters release];
       }
    }
    NSMutableURLRequest *request = [super requestWithMethod:@"POST"
													   path:path
												 parameters:parameters];
    NSLog(@"request is %@",request);
	/* 30 seconds time out */
	[request setTimeoutInterval:30.0f];
	return request;
}


@end
