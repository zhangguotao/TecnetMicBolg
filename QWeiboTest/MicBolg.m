//
//  MicBolg.m
//  QWeiboTest
//
//  Created by 张国涛 on 12-10-10.
//  Copyright (c) 2012年 张国涛. All rights reserved.
//

#import "MicBolg.h"
#import "HTTPClict.h"

@implementation MicBolg

+ (MicBolg *)shareInstance
{
    static MicBolg *_shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[MicBolg alloc] init];
    });
    return _shareInstance;
}

/* post a new micblog */

- (void)postNewMicBlog:(id)target
        withAccesToken:(NSString *)access_token
            withOpenid:(NSString *)openid
           withSuccess:(SEL)success
            withFaiure:(SEL)failure
{
    [[HTTPClict shareCliect]
     getPath:@""
     parameters:[NSDictionary dictionaryWithObjectsAndKeys:
     @"json",                               @"format",
     @"This is a test for share from app",  @"content",
     @"220.181.111.147",                    @"clientip",
     access_token,                          @"access_token",
     openid,                                @"openid",nil]
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
         NSString  *str = [[[NSString alloc] initWithData:responseObject
                                                encoding:NSUTF8StringEncoding] autorelease];
         NSLog(@"hello is %@",str);
         [target performSelector:success withObject:str];
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     
         NSLog(@"网络请求错误%@",[error localizedDescription]);
         [target performSelector:failure withObject:error];
     }];
}

@end
