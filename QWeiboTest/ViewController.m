//
//  ViewController.m
//  QWeiboTest
//
//  Created by 张国涛 on 12-10-9.
//  Copyright (c) 2012年 张国涛. All rights reserved.
//

#import "ViewController.h"
#import "OuathViewController.h"

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton  *Tbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    Tbutton.frame = CGRectMake(10, 50, 300, 50);
    Tbutton.backgroundColor = [UIColor grayColor];
    [Tbutton setTitle:@"分享到腾讯微博" forState:UIControlStateNormal];
    [Tbutton addTarget:self
                action:@selector(doShare:)
      forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:Tbutton];
}

#pragma mark -UIButton Selecter

- (void)doShare:(id)sender
{
    OuathViewController  *viewController = [[[OuathViewController alloc] init] autorelease];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)dealloc
{
    [super dealloc];
}

@end
