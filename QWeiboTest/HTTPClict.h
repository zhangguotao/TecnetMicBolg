//
//  HTTPClict.h
//  QWeiboTest
//
//  Created by 张国涛 on 12-10-10.
//  Copyright (c) 2012年 张国涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface HTTPClict : AFHTTPClient

+ (HTTPClict *)shareCliect;

+ (HTTPClict *)shareCliectSinaOuath;

+ (HTTPClict *)shareCliectSinaPost;

@end
