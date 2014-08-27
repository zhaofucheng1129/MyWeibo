//
//  SkinsManager.h
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-25.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSkinDidChangeNotification @"kSkinDidChangeNotification"

@interface SkinsManager : NSObject
//皮肤名称
@property(nonatomic,retain)NSString *skinName;
//皮肤配置文件
@property(nonatomic,retain)NSDictionary *skinsPlist;
//lable字体颜色plist文件
@property(nonatomic,retain)NSDictionary *labelColorPlist;

+ (SkinsManager *)shareInstance;
//返回当前主题下图片名对应的图片
- (UIImage *)getSkinImage:(NSString *)imageName;
//通过labelName获得对应的颜色
- (UIColor *)getColorWithLabelName:(NSString *)labelName;
@end
