//
//  SinaDataService.h
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-27.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

//com.sina.weibo.SNWeiboSDKDemo
#define kAppKey         @"4119862942"
#define kAppSecret      @"b0c0dd997c99c04f8df4ec37a4846c96"
#define kRedirectURI    @"https://api.weibo.com/oauth2/default.html"

#define kSinaAuthorizeURL   @"https://api.weibo.com/oauth2/authorize"
#define kSinaAccessTokenKey @"kSinaAccessTokenKey"
#define kSinaTokenExpiresInKey @"kSinaTokenExpiresInKey"
#define kSinaUIDKey @"kSinaUIDKey"
#define kSinaAccessTokenURL @"https://api.weibo.com/oauth2/access_token"
#define k
#import <Foundation/Foundation.h>
#import "NetRequest.h"

@interface SinaDataService : NSObject
/**
 拼接授权地址
 返回给登陆页面加载
 */
+(NSURL *)authorizeURL;
/**
 判断是否有可用的Token
 */
+(BOOL)isAuthorized;
/**
 换取Token
 */
+ (void)getAccessToken:(NSString *)code success:(void (^) (BOOL isSuccess))isSuccess;
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
+ (void)getStatusDataWithSinceId:(NSString *)SinceId MaxId:(NSString *)maxId Count:(NSInteger)count Page:(NSInteger)page BaseApp:(NSInteger)baseApp Feature:(NSInteger)feature TrimUser:(NSInteger)trimUser Success:(void(^)(BOOL isSuccess,NSMutableArray *array))isSuccess;

/**
 * 获取某个用户的各种消息未读数
 * @param   source          false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 * @param   access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 * @param   uid             true	int64	需要获取消息未读数的用户UID，必须是当前登录用户。
 * @param   callback        false	string	JSONP回调函数，用于前端调用返回JS格式的信息。
 * @param   unread_message	false	boolean	未读数版本。0：原版未读数，1：新版未读数。默认为0。
 */
+ (void)getStatusUnreadCountWithSuccess:(void(^)(BOOL isSuccess,NSDictionary *result))isSuccess;


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
+ (void)getCommentDataWithId:(NSString *)id SinceId:(NSString *)sinceId MaxId:(NSString *)maxId Count:(NSString *)count Page:(NSString *)page FilterByAuthor:(NSString *)filterByAuthor Success:(void(^)(BOOL isSuccess,NSMutableArray *array))isSuccess;
@end
