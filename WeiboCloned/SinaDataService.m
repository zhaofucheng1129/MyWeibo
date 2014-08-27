//
//  SinaDataService.m
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-27.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "SinaDataService.h"
#import "NetRequest.h"

#import "Status.h"
#import "Comment.h"

@implementation SinaDataService
/**
 拼接授权地址
 返回给登陆页面加载
 */
+(NSURL *)authorizeURL
{
    NSString *authorizeStr = [NSString stringWithFormat:@"%@?client_id=%@&response_type=code&redirect_uri=%@",kSinaAuthorizeURL,kAppKey,kRedirectURI];
    return [NSURL URLWithString:authorizeStr];
}

/**
 判断是否有可用的Token
 */
+(BOOL)isAuthorized
{
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kSinaAccessTokenKey];
    NSDate *expiresDate = [[NSUserDefaults standardUserDefaults] objectForKey:kSinaTokenExpiresInKey];
    if (expiresDate) {
        return (NSOrderedDescending == [expiresDate compare:[NSDate date]] && accessToken);
    }
    return NO;
}

+ (void)getAccessToken:(NSString *)code success:(void (^) (BOOL isSuccess))isSuccess
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:kAppKey forKey:@"client_id"];
    [params setObject:kAppSecret forKey:@"client_secret"];
    [params setObject:@"authorization_code" forKey:@"grant_type"];
    [params setObject:kRedirectURI forKey:@"redirect_uri"];
    [params setObject:code forKey:@"code"];
    
    [NetRequest requestWithURL:kSinaAccessTokenURL params:params httpMethod:@"POST" completionBlock:^(id result) {
        [[NSUserDefaults standardUserDefaults] setObject:[result objectForKey:@"access_token"] forKey:kSinaAccessTokenKey];
        NSDate *expiresIn = [NSDate dateWithTimeIntervalSinceNow:[[result objectForKey:@"expires_in"] intValue]];
        [[NSUserDefaults standardUserDefaults] setObject:expiresIn forKey:kSinaTokenExpiresInKey];
        [[NSUserDefaults standardUserDefaults] setObject:[result objectForKey:@"uid"] forKey:kSinaUIDKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        isSuccess(YES);
    } errorBlock:^(id error) {
        isSuccess(NO);
    }];
}

/**
 * 获取当前登录用户及其所关注用户的最新微博
 * @param   SinceId     若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
 * @param   maxId       若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
 * @param   count       单页返回的记录条数，最大不超过100，默认为20。
 * @param   page        返回结果的页码，默认为1。
 * @param   baseApp     是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
 * @param   feature     过滤类型ID，0：全部、1：原创、2：图片、3：视频、4：音乐，默认为0。
 * @param   trimUser    返回值中user字段开关，0：返回完整user字段、1：user字段仅返回user_id，默认为0。
 */
+ (void)getStatusDataWithSinceId:(NSString *)SinceId MaxId:(NSString *)maxId Count:(NSInteger)count Page:(NSInteger)page BaseApp:(NSInteger)baseApp Feature:(NSInteger)feature TrimUser:(NSInteger)trimUser Success:(void(^)(BOOL isSuccess,NSMutableArray *array))isSuccess
{
    NSString *tokenString = [[NSUserDefaults standardUserDefaults] objectForKey:kSinaAccessTokenKey];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:tokenString forKey:@"access_token"];
    [params setObject:SinceId forKey:@"since_id"];
    [params setObject:maxId forKey:@"max_id"];
    [params setObject:[NSString stringWithFormat:@"%d",count] forKey:@"count"];
    [params setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [params setObject:[NSString stringWithFormat:@"%d",baseApp] forKey:@"base_app"];
    [params setObject:[NSString stringWithFormat:@"%d",feature] forKey:@"feature"];
    [params setObject:[NSString stringWithFormat:@"%d",trimUser] forKey:@"trim_user"];
    
    [NetRequest requestWithURL:@"https://api.weibo.com/2/statuses/home_timeline.json" params:params httpMethod:@"GET" completionBlock:^(id result) {
        NSArray *array = [result objectForKey:@"statuses"];
        NSMutableArray *statusArray = [[NSMutableArray alloc] initWithCapacity:array.count];
        for (NSDictionary *statusDic in array) {
            Status *status = [[Status alloc] initWithDataDic:statusDic];
            [statusArray addObject:status];
            [status release];
        }
        if (isSuccess != nil) {
            isSuccess(YES,statusArray);
        }
    } errorBlock:^(id error) {
        if (isSuccess != nil) {
            isSuccess(NO,nil);
        }
    }];
}

/**
 * 获取某个用户的各种消息未读数
 * @param   source          false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 * @param   access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 * @param   uid             true	int64	需要获取消息未读数的用户UID，必须是当前登录用户。
 * @param   callback        false	string	JSONP回调函数，用于前端调用返回JS格式的信息。
 * @param   unread_message	false	boolean	未读数版本。0：原版未读数，1：新版未读数。默认为0。
 */
+ (void)getStatusUnreadCountWithSuccess:(void(^)(BOOL isSuccess,NSDictionary *result))isSuccess
{
    NSString *tokenString = [[NSUserDefaults standardUserDefaults] objectForKey:kSinaAccessTokenKey];
    NSString *uidString = [[NSUserDefaults standardUserDefaults] objectForKey:kSinaUIDKey];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:tokenString forKey:@"access_token"];
    [params setObject:uidString forKey:@"uid"];
    
    [NetRequest requestWithURL:@"https://rm.api.weibo.com/2/remind/unread_count.json" params:params httpMethod:@"GET" completionBlock:^(id result) {

        if (isSuccess != nil) {
            isSuccess(YES,result);
        }
    } errorBlock:^(id error) {
        if (isSuccess != nil) {
            isSuccess(NO,nil);
        }
    }];
}

/**
 * 根据微博ID返回某条微博的评论列表
 * @param   source              false   string  采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 * @param   access_token        false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 * @param   id                  true	int64	需要查询的微博ID。
 * @param   since_id            false	int64	若指定此参数，则返回ID比since_id大的评论（即比since_id时间晚的评论），默认为0。
 * @param   max_id              false	int64	若指定此参数，则返回ID小于或等于max_id的评论，默认为0。
 * @param   count               false	int     单页返回的记录条数，默认为50。
 * @param   page                false	int     返回结果的页码，默认为1。
 * @param   filter_by_author	false	int	作者筛选类型，0：全部、1：我关注的人、2：陌生人，默认为0。
 */
+ (void)getCommentDataWithId:(NSString *)sid SinceId:(NSString *)sinceId MaxId:(NSString *)maxId Count:(NSString *)count Page:(NSString *)page FilterByAuthor:(NSString *)filterByAuthor Success:(void(^)(BOOL isSuccess,NSMutableArray *array))isSuccess
{
    NSString *tokenString = [[NSUserDefaults standardUserDefaults] objectForKey:kSinaAccessTokenKey];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:tokenString forKey:@"access_token"];
    [params setObject:sid forKey:@"id"];
    [params setObject:sinceId forKey:@"since_id"];
    [params setObject:maxId forKey:@"max_id"];
    [params setObject:count forKey:@"count"];
    [params setObject:page forKey:@"page"];
    [params setObject:filterByAuthor forKey:@"filter_by_author"];
    
    [NetRequest requestWithURL:@"https://api.weibo.com/2/comments/show.json" params:params httpMethod:@"GET" completionBlock:^(id result) {
        
        NSArray *array = [result objectForKey:@"comments"];
        NSMutableArray *commentsArray = [[NSMutableArray alloc] initWithCapacity:array.count];
        for (NSDictionary *commentDic in array) {
            Comment *comment = [[Comment alloc] initWithDataDic:commentDic];
            [commentsArray addObject:comment];
            [comment release];
        }
        if (isSuccess != nil) {
            isSuccess(YES,commentsArray);
        }

    } errorBlock:^(id error) {
        if (isSuccess != nil) {
            isSuccess(NO,nil);
        }
    }];
}

@end
