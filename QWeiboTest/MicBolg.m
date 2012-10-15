//
//  MicBolg.m
//  QWeiboTest
//
//  Created by 张国涛 on 12-10-10.
//  Copyright (c) 2012年 张国涛. All rights reserved.
//

#define SINASECRET @"e84b502214e7eb7928e996a6794264e0"

#import "MicBolg.h"
#import "HTTPClict.h"
#import "JSONKit.h"

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
     @"801193272",                          @"oauth_consumer_key",
     @"all",                                @"scope",
     @"2.a",                                @"oauth_version",
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



- (void)getSinaMicblogAccessToken:(id)target
                         withCode:(NSString *)code 
                      withSuccess:(SEL)success
                      withFailure:(SEL)failure
{
    [[HTTPClict shareCliectSinaOuath]
     getPath:@""
     parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                 @"753328578",                          @"client_id",
                 SINASECRET,                            @"client_secret",
                 @"authorization_code",                 @"grant_type",
                 code,                                  @"code",
                 @"http://edaijia.cn",                  @"redirect_uri",nil]
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
         NSString  *str = [[[NSString alloc] initWithData:responseObject
                                                 encoding:NSUTF8StringEncoding] autorelease];
         [target performSelector:success withObject:str];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"网络请求错误%@",[error localizedDescription]);
         [target performSelector:failure withObject:error];
     }];
}

- (void)postSinaMicblog:(id)target
        withAccessToken:(NSString *)accesstoken
            withSuccess:(SEL)success
            withFailure:(SEL)failure
{
    [[HTTPClict shareCliectSinaPost]
     getPath:@""
     parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                 accesstoken,                           @"access_token",
                 @"hello",                          @"status",nil]
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
         NSLog(@"str is %@",responseObject);
         NSDictionary  *dictionary = (NSDictionary *)responseObject;
         if (dictionary) {
             Alert(@"恭喜您！",@"微博发表成功");
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSString  *errorStr = [error localizedDescription];
         NSRange   range = [errorStr rangeOfString:@"400"];
         if (range.length > 0) {
             Alert(@"抱歉", @"您不能在段时间内重复发送相同的微博");
         } else {
             Alert(@"抱歉",@"请检查您的网络连接");
         }

     }];

}

@end
