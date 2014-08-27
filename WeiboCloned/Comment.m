//
//  Comment.m
//  WeiboCloned
//
//  Created by ZhaoFucheng on 14-8-16.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "Comment.h"

@implementation Comment

- (void)setAttributes:(NSDictionary *)dataDic {
    [super setAttributes:dataDic];
    
    NSDictionary *user = [dataDic objectForKey:@"user"];
    if (user != nil) {
        User *userModel = [[User alloc] initWithDataDic:user];
        self.user = userModel;
        [userModel release];
    }
    
    NSDictionary *status = [dataDic objectForKey:@"status"];
    if (status != nil) {
        Status *statusModel = [[Status alloc] initWithDataDic:status];
        self.status = statusModel;
        [statusModel release];
    }
}

@end
