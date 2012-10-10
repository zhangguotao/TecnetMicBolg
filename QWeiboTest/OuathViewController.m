//
//  OuathViewController.m
//  QWeiboTest
//
//  Created by 张国涛 on 12-10-9.
//  Copyright (c) 2012年 张国涛. All rights reserved.
//
#define  APP_KEY @"801193272"
#define  REDIRECT_URL @"http://edaijia.cn/"

#import "OuathViewController.h"

@interface OuathViewController ()
@property (strong , nonatomic) UIWebView  *webview;
@property (copy   , nonatomic) NSString   *urlstr;

- (void)saveAccessToken:(NSString *)urlString;

@end


@implementation OuathViewController

@synthesize webview;
@synthesize urlstr;

- (id)init
{
    if (self = [super init]) {
        self.title = @"腾讯微博授权";
        self.urlstr = [NSString stringWithFormat:@"https://open.t.qq.com/cgi-bin/oauth2/authorize?client_id=%@&response_type=token&redirect_uri=%@",APP_KEY,REDIRECT_URL];
    }
    return  self;
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
/*
edaijia.cn#access_token=216358109659f07936e1ba47f3e37bd7&expires_in=604800&openid=C4E977D616F12550D6DF1DF3D554EBEA&openkey=3AB1F01E08E9FE44DA04A4789BF9B9B8&refresh_token=517073e6c4f118e786902134db281aca&name=testweibo2009&nick=%E5%BC%A0%E5%9B%BD%E6%B6%9B
*/

#pragma mark -UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString   *geturl = request.URL.absoluteString;
    /*  checking if get the access_token */
    NSRange  range = [geturl rangeOfString:@"#"];
    if (range.length > 0) {
        [self saveAccessToken:geturl];
        [self.navigationController popToRootViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
     Alert(@"错误", @"请检查您的网络连接!");
}

- (void)saveAccessToken:(NSString *)urlString
{
    NSArray  *strArray = [urlString componentsSeparatedByString:@"#"];
    //NSLog(@"url is %@",[strArray objectAtIndex:1]);
    /* cut any import key to save */
    NSString *access_token = [[strArray objectAtIndex:1]
                              substringWithRange:NSMakeRange(13,32)];
    NSString *openid = [[strArray objectAtIndex:1]
                        substringWithRange:NSMakeRange(71,32)];
    NSString *refresh_token = [[strArray objectAtIndex:1]
                               substringWithRange:NSMakeRange(159,32)];
    /* save access_token and openid to userdefault  */
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setValue:access_token forKey:@"ACCESS_TOKEN"];
    [userdefault setValue:openid forKey:@"OPENID"];
    [userdefault setValue:refresh_token forKey:@"REFRESH_TOKEN"];
    [userdefault synchronize];
}

- (void)dealloc
{
    self.webview = nil;
    [super dealloc];
}

@end
