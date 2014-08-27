//
//  User.m
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-28.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "User.h"
#import "Status.h"
@implementation User

- (NSDictionary *)attributeMapDictionary
{
    NSDictionary *mapAtt = @{
                             @"id": @"id",
                             @"idstr": @"idstr",
                             @"screen_name": @"screen_name",
                             @"name": @"name",
                             @"province": @"province",
                             @"city": @"city",
                             @"location": @"location",
                             @"description": @"description",
                             @"url": @"url",
                             @"profile_image_url": @"profile_image_url",
                             @"profile_url": @"profile_url",
                             @"domain": @"domain",
                             @"weihao": @"weihao",
                             @"gender": @"gender",
                             @"followers_count": @"followers_count",
                             @"friends_count": @"friends_count",
                             @"statuses_count": @"statuses_count",
                             @"favourites_count": @"favourites_count",
                             @"created_at": @"created_at",
                             @"following": @"following",
                             @"allow_all_act_msg": @"allow_all_act_msg",
                             @"geo_enabled": @"geo_enabled",
                             @"verified": @"verified",
                             @"verified_type": @"verified_type",
                             @"remark": @"remark",
                             @"status": @"status",
                             @"allow_all_comment": @"allow_all_comment",
                             @"avatar_large": @"avatar_large",
                             @"avatar_hd": @"avatar_hd",
                             @"verified_reason": @"verified_reason",
                             @"follow_me": @"follow_me",
                             @"online_status": @"online_status",
                             @"bi_followers_count": @"bi_followers_count",
                             @"lang": @"lang"
                             };
    return mapAtt;
}

- (void)setAttributes:(NSDictionary *)dataDic {
    [super setAttributes:dataDic];
    
    NSDictionary *status = [dataDic objectForKey:@"status"];
    if (status != nil) {
        Status *statusModel = [[Status alloc] initWithDataDic:status];
        self.status = statusModel;
        [statusModel release];
    }
}

@end
