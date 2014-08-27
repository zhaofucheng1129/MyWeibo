//
//  Status.m
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-28.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "Status.h"

@implementation Status

- (NSDictionary *)attributeMapDictionary
{
    NSDictionary *mapAtt = @{
                             @"created_at": @"created_at",
                             @"id": @"id",
                             @"idstr": @"idstr",
                             @"text": @"text",
                             @"source": @"source",
                             @"favorited": @"favorited",
                             @"truncated": @"truncated",
                             @"thumbnail_pic": @"thumbnail_pic",
                             @"bmiddle_pic": @"bmiddle_pic",
                             @"original_pic": @"original_pic",
                             @"reposts_count": @"reposts_count",
                             @"comments_count": @"comments_count",
                             @"attitudes_count": @"attitudes_count",
                             @"visible": @"visible",
                             @"pic_urls": @"pic_urls",
                             @"ad": @"ad"
                             };
    return mapAtt;
}

- (void)setAttributes:(NSDictionary *)dataDic {
    [super setAttributes:dataDic];
    
    NSDictionary *geo = [dataDic objectForKey:@"geo"];
    if (geo != nil) {
        Geo *geoModel = [[Geo alloc] init];
        self.geo = geoModel;
        [geoModel release];
    }
    
    NSDictionary *user = [dataDic objectForKey:@"user"];
    if (user != nil) {
        User *userModel = [[User alloc] initWithDataDic:user];
        self.user = userModel;
        [userModel release];
    }
    
    NSDictionary *retweeted_status = [dataDic objectForKey:@"retweeted_status"];
    if (retweeted_status != nil) {
        Status *statusModel = [[Status alloc] initWithDataDic:retweeted_status];
        self.retweeted_status = statusModel;
        [statusModel release];
    }
}

@end
