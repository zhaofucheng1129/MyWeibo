//
//  DataService.h
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-27.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

typedef void(^CompletionBlock)(id result);
typedef void(^ErrorBlock)(id error);

@interface NetRequest : NSObject

+ (ASIHTTPRequest *)requestWithURL:(NSString *)urlString params:(NSMutableDictionary *)params httpMethod:(NSString *)httpMethod completionBlock:(CompletionBlock)block errorBlock:(ErrorBlock)error;

@end
