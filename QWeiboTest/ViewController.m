//
//  ViewController.m
//  QWeiboTest
//
//  Created by 张国涛 on 12-10-9.
//  Copyright (c) 2012年 张国涛. All rights reserved.
//

#import "ViewController.h"
#import "OuathViewController.h"
#import "MicBolg.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)init
{
    if (self = [super init]) {
        self.title = @"分享到微博";
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    UIButton  *Tbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    Tbutton.frame = CGRectMake(10, 50, 300, 50);
    Tbutton.backgroundColor = [UIColor clearColor];
    [Tbutton setTitle:@"分享到腾讯微博" forState:UIControlStateNormal];
    [Tbutton addTarget:self
                action:@selector(doShare:)
      forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:Tbutton];
}

#pragma mark -UIButton Selecter

- (void)doShare:(id)sender
{
    /* check out if ouathed */
    NSUserDefaults  *userdefault = [NSUserDefaults standardUserDefaults];
    if ([userdefault valueForKey:@"ACCESS_TOKEN"] &&
        [userdefault valueForKey:@"OPENID"]) {
        /* post a new micbolg */
         [[MicBolg shareInstance]
          postNewMicBlog:self
          withAccesToken:[userdefault valueForKey:@"ACCESS_TOKEN"]
          withOpenid:[userdefault valueForKey:@"OPENID"]
          withSuccess:@selector(doSuccess:)
          withFaiure:@selector(doFailure:)];
    } else {
        /* jump to ouath page */
        OuathViewController  *viewController = [[[OuathViewController alloc] init] autorelease];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    [userdefault synchronize];
}

#pragma mark  -networking callback

- (void)doSuccess:(id)sender
{
    Alert(@"恭喜您", @"发表微博成功");
}

- (void)doFailure:(id)sender
{
    Alert(@"抱歉了", @"发表微博失败");
}

- (void)dealloc
{
    [super dealloc];
}

@end
