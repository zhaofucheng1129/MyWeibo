//
//  Status.h
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-28.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "BaseModel.h"
#import "User.h"
#import "Geo.h"

@interface Status : BaseModel

@property(nonatomic,copy)NSString *created_at; //微博创建时间
@property(nonatomic,retain)NSNumber *id; //微博ID
@property(nonatomic,copy)NSString *idstr; //字符串型的微博ID
@property(nonatomic,copy)NSString *text; //微博信息内容
@property(nonatomic,copy)NSString *source; //微博来源
@property(nonatomic,retain)NSNumber *favorited; //是否已收藏，true：是，false：否
@property(nonatomic,retain)NSNumber *truncated; //是否被截断，true：是，false：否
@property(nonatomic,copy)NSString *thumbnail_pic; //缩略图片地址，没有时不返回此字段
@property(nonatomic,copy)NSString *bmiddle_pic; //中等尺寸图片地址，没有时不返回此字段
@property(nonatomic,copy)NSString *original_pic; //原始图片地址，没有时不返回此字段
@property(nonatomic,retain)Geo *geo; //地理信息字段
@property(nonatomic,retain)User *user; //微博作者的用户信息字段
@property(nonatomic,retain)Status *retweeted_status; //被转发的原微博信息字段，当该微博为转发微博时返回
@property(nonatomic,retain)NSNumber *reposts_count; //转发数
@property(nonatomic,retain)NSNumber *comments_count; //评论数
@property(nonatomic,retain)NSNumber *attitudes_count; //表态数
@property(nonatomic,retain)NSDictionary *visible; //微博的可见性及指定可见分组信息。该object中type取值，0：普通微博，1：私密微博，3：指定分组微博，4：密友微博；list_id为分组的组号
@property(nonatomic,retain)NSArray *pic_urls; //微博配图地址。多图时返回多图链接。无配图返回“[]”
@property(nonatomic,retain)NSArray *ad; //微博流内的推广微博ID

@end
