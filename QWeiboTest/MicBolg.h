//
//  MicBolg.h
//  QWeiboTest
//
//  Created by 张国涛 on 12-10-10.
//  Copyright (c) 2012年 张国涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MicBolg : NSObject

+ (MicBolg *)shareInstance;

/* post a new micblog */

- (void)postNewMicBlog:(id)target
        withAccesToken:(NSString*)access_token
            withOpenid:(NSString*)openid
           withSuccess:(SEL)success
            withFaiure:(SEL)failure;


@end
