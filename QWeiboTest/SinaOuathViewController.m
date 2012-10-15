//
//  SinaOuathViewController.m
//  QWeiboTest
//
//  Created by 张国涛 on 12-10-10.
//  Copyright (c) 2012年 张国涛. All rights reserved.
//

#define SINA_KEY @"753328578"
#define SINA_DEDIRECTURL @"http://edaijia.cn"

#import "SinaOuathViewController.h"
#import "MicBolg.h"
#import "JSONKit.h"

@interface SinaOuathViewController ()

@property (strong , nonatomic) UIWebView  *webview;
@property (copy   , nonatomic) NSString   *urlstr;

- (NSString *)getExpiresTimes:(NSString *)expirestime;

@end

@implementation SinaOuathViewController

- (id)init
{
    if (self = [super init]) {
        self.title = @"新浪微博授权";
        self.urlstr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@&response_type=code&display=mobile",SINA_KEY,SINA_DEDIRECTURL];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    NSURL  *url = [NSURL URLWithString:self.urlstr];
    NSURLRequest  *request = [[NSURLRequest  alloc] initWithURL:url];
    self.webview = [[[UIWebView alloc]
                     initWithFrame:CGRectMake(0,0,320,480)]
                    autorelease];
    [self.webview loadRequest:request];
    self.webview.delegate = self;
    [self.view addSubview:self.webview];
    [request  release];
}

#pragma mark -UIWebview Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString   *geturl = request.URL.absoluteString;
    if (geturl.length == 56) {
        NSArray  *strArray = [geturl componentsSeparatedByString:@"="];
        NSString *code = [strArray objectAtIndex:1];
        /* get url code to request access_token */
        [[MicBolg shareInstance] getSinaMicblogAccessToken:self
                                                  withCode:code
                                               withSuccess:@selector(doSuccess:)
                                               withFailure:@selector(doFailure:)];
        
        return NO;
    }

    return YES;
}

/* net working delegate */

- (void)doSuccess:(NSString *)sender
{
    NSLog(@"接收到的数据是:%@",sender);
    NSDictionary  *dictionary = [sender objectFromJSONString];
    NSString   *access_token = [dictionary valueForKey:@"access_token"];
    NSString   *expires_in = [dictionary valueForKey:@"expires_in"];
    /* save sina access_token to key */
    NSUserDefaults  *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setValue:access_token forKey:@"SINAACCESSTOKEN"];
    [userdefault setValue:[self getExpiresTimes:expires_in] forKey:@"SINAEXPIRESIN"];
    [userdefault synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}


//  count expires_in time
- (NSString *)getExpiresTimes:(NSString *)expirestime
{
    double  expire = [expirestime doubleValue];
    id  expirestr = [[NSDate date] dateByAddingTimeInterval:expire];
    return [NSString stringWithFormat:@"%@",expirestr];
}


- (void)doFailure:(id)sender
{
    Alert(@"网络连接错误", @"请检查您的网络连接");
}

- (void)dealloc
{
    self.webview = nil;
    [super dealloc];
}

@end
