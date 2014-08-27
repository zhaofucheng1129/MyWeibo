//
//  DataService.m
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-27.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "NetRequest.h"

@implementation NetRequest

+ (ASIHTTPRequest *)requestWithURL:(NSString *)urlString params:(NSMutableDictionary *)params httpMethod:(NSString *)httpMethod completionBlock:(CompletionBlock)block errorBlock:(ErrorBlock)error
{
    
    NSComparisonResult comparGet = [httpMethod caseInsensitiveCompare:@"GET"];
    if (comparGet == NSOrderedSame) {
        urlString = [urlString stringByAppendingString:@"?"];
        NSMutableString *paramsString = [NSMutableString string];
        NSArray *allKeys = [params allKeys];
        for (NSInteger i = 0; i < params.count; i++) {
            NSString *key = [allKeys objectAtIndex:i];
            id value = [params objectForKey:key];
            
            [paramsString appendFormat:@"%@=%@",key ,value];
            if (i < params.count-1) {
                [paramsString appendString:@"&"];
            }
        }
        if (paramsString.length > 0) {
            urlString = [urlString stringByAppendingFormat:@"%@",paramsString];
        }
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:60];
    [request setRequestMethod:httpMethod];
    NSComparisonResult comparPost = [httpMethod caseInsensitiveCompare:@"POST"];
    if (comparPost == NSOrderedSame) {
        NSArray *allkeys = [params allKeys];
        for (NSInteger i = 0; i < params.count; i++) {
            NSString *key = [allkeys objectAtIndex:i];
            id value = [params objectForKey:key];
            if ([value isKindOfClass:[NSData class]]) {
                [request addData:value forKey:key];
            }
            else
            {
                [request addPostValue:value forKey:key];
            }
        }
    }
    
    [request setCompletionBlock:^{
        NSData *data = [request responseData];
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (block != nil) {
            block(result);
        }
    }];
    
    [request setFailedBlock:^{
        NSString *errorInfo = @"请求网络出错啦";
        if (error != nil) {
            error(errorInfo);
        }
    }];
    
    [request startAsynchronous];
    
    return request;
}

@end
