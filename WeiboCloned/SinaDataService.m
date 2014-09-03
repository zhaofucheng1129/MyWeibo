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

/**
 * 根据用户ID获取用户信息
 * @param source        false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 * @param access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 * @param uid           false	int64	需要查询的用户ID。
 * @param screen_name	false	string	需要查询的用户昵称。
 */
+ (void)getUserDataWithUid:(NSString *)uid ScreenName:(NSString *)screenName Success:(void(^)(BOOL isSuccess,User *user))isSuccess
{
    NSString *tokenString = [[NSUserDefaults standardUserDefaults] objectForKey:kSinaAccessTokenKey];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:tokenString forKey:@"access_token"];
    [params setObject:uid forKey:@"uid"];
    [params setObject:screenName forKey:@"screen_name"];
    [NetRequest requestWithURL:@"https://api.weibo.com/2/users/show.json" params:params httpMethod:@"GET" completionBlock:^(id result) {
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
 * 发布一条新微博
 * @param   source          false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 * @param   access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 * @param   status          true	string	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
 * @param   visible         false	int	微博的可见性，0：所有人能看，1：仅自己可见，2：密友可见，3：指定分组可见，默认为0。
 * @param   list_id         false	string	微博的保护投递指定分组ID，只有当visible参数为3时生效且必选。
 * @param   lat             false	float	纬度，有效范围：-90.0到+90.0，+表示北纬，默认为0.0。
 * @param   long            false	float	经度，有效范围：-180.0到+180.0，+表示东经，默认为0.0。
 * @param   annotations     false	string	元数据，主要是为了方便第三方应用记录一些适合于自己使用的信息，每条微博可以包含一个或者多个元数据，必须以json字串的形式提交，字串长度不超过512个字符，具体内容可以自定。
 * @param   rip             false	string	开发者上报的操作用户真实IP，形如：211.156.0.1。
 */
+ (void)sendSimpleWeiboWithStatus:(NSString *)status Visible:(NSString *)visible ListId:(NSString *)listId Lat:(CGFloat)lat Long:(CGFloat)longF Annotations:(NSString *)annotations Rip:(NSString *)rip Success:(void(^)(BOOL isSuccess))isSuccess
{
    NSString *tokenString = [[NSUserDefaults standardUserDefaults] objectForKey:kSinaAccessTokenKey];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:tokenString forKey:@"access_token"];
    [params setObject:status forKey:@"status"];
    [NetRequest requestWithURL:@"https://api.weibo.com/2/statuses/update.json" params:params httpMethod:@"POST" completionBlock:^(id result) {
        if (isSuccess != nil) {
            isSuccess(YES);
        }
    } errorBlock:^(id error) {
        if (isSuccess != nil) {
            isSuccess(NO);
        }
    }];
}

@end
