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
#import "User.h"

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

/**
 * 根据用户ID获取用户信息
 * @param source        false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 * @param access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 * @param uid           false	int64	需要查询的用户ID。
 * @param screen_name	false	string	需要查询的用户昵称。
 */
+ (void)getUserDataWithUid:(NSString *)uid ScreenName:(NSString *)screenName Success:(void(^)(BOOL isSuccess,User *user))isSuccess;


/**
 * 发布一条新微博
 * @param   source          false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 * @param   access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 * @param   status          true	string	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
 * @param   visible         false	int     微博的可见性，0：所有人能看，1：仅自己可见，2：密友可见，3：指定分组可见，默认为0。
 * @param   list_id         false	string	微博的保护投递指定分组ID，只有当visible参数为3时生效且必选。
 * @param   lat             false	float	纬度，有效范围：-90.0到+90.0，+表示北纬，默认为0.0。
 * @param   long            false	float	经度，有效范围：-180.0到+180.0，+表示东经，默认为0.0。
 * @param   annotations     false	string	元数据，主要是为了方便第三方应用记录一些适合于自己使用的信息，每条微博可以包含一个或者多个元数据，必须以json字串的形式提交，字串长度不超过512个字符，具体内容可以自定。
 * @param   rip             false	string	开发者上报的操作用户真实IP，形如：211.156.0.1。
 */
+ (void)sendSimpleWeiboWithStatus:(NSString *)status Visible:(NSString *)visible ListId:(NSString *)listId Lat:(CGFloat)lat Long:(CGFloat)longF Annotations:(NSString *)annotations Rip:(NSString *)rip Success:(void(^)(BOOL isSuccess))isSuccess;

/**
 * 获取附近地点
 * @param   source          false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 * @param   access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 * @param   lat             true	float	纬度，有效范围：-90.0到+90.0，+表示北纬。
 * @param   long            true	float	经度，有效范围：-180.0到+180.0，+表示东经。
 * @param   range           false	int     查询范围半径，默认为2000，最大为10000，单位米。
 * @param   q               false	string	查询的关键词，必须进行URLencode。
 * @param   category        false	string	查询的分类代码，取值范围见：分类代码对应表。
 * @param   count           false	int     单页返回的记录条数，默认为20，最大为50。
 * @param   page            false	int     返回结果的页码，默认为1。
 * @param   sort            false	int     排序方式，0：按权重，1：按距离，3：按签到人数。默认为0。
 * @param   offset          false	int     传入的经纬度是否是纠偏过，0：没纠偏、1：纠偏过，默认为0。
 */
+ (void)getNearbyPoisWithLat:(CGFloat)lat Long:(CGFloat)longF range:(NSInteger)range Q:(NSString *)q Category:(NSString *)category Count:(NSInteger)count Page:(NSInteger)page Sort:(NSInteger)sort Offset:(NSInteger)offset Success:(void(^)(BOOL isSuccess,NSDictionary *result))isSuccess;
@end
