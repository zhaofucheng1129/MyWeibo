//
//  SkinsManager.m
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-25.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "SkinsManager.h"

static SkinsManager *sigleton = nil;

@implementation SkinsManager

+ (SkinsManager *)shareInstance
{
    @synchronized(self){
        if (sigleton == nil)
        {
            sigleton = [[SkinsManager alloc] init];
        }
    }
    return sigleton;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString *skinPath = [[NSBundle mainBundle] pathForResource:@"Skins" ofType:@"plist"];
        self.skinsPlist = [NSDictionary dictionaryWithContentsOfFile:skinPath];
        //为空 默认主题
        self.skinName = nil;
    }
    return self;
}

//通过图片名称取得UIImage
- (UIImage *)getSkinImage:(NSString *)imageName
{
    if (imageName.length == 0) {
        return nil;
    }
    NSString *skinPath = [self getSkinPath];
    NSString *imagePath = [skinPath stringByAppendingPathComponent:imageName];
    
    return [UIImage imageWithContentsOfFile:imagePath];
}
//获取皮肤路径
- (NSString *)getSkinPath
{
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    if (self.skinName == nil) {
        return resourcePath;
    }
    NSString *skinPath = [self.skinsPlist objectForKey:self.skinName];
    return [resourcePath stringByAppendingPathComponent:skinPath];
}

- (UIColor *)getColorWithLabelName:(NSString *)labelName
{
    if (labelName.length == 0) {
        return nil;
    }
    NSString *rgbString = [self.labelColorPlist objectForKey:labelName];
    NSArray *rgbArray = [rgbString componentsSeparatedByString:@","];
    if (rgbArray.count == 3) {
        CGFloat red = [[rgbArray objectAtIndex:0] floatValue];
        CGFloat green = [[rgbArray objectAtIndex:1] floatValue];
        CGFloat blue = [[rgbArray objectAtIndex:2] floatValue];
        UIColor *color = UIColorMake(red, green, blue, 1);
        return color;
    }
    return nil;
}

#pragma mark - Override Method
- (void)setSkinName:(NSString *)skinName
{
    if (_skinName != skinName) {
        [_skinName release];
        _skinName = [skinName retain];
    }
    
    NSString *skinPath = [self getSkinPath];
    NSString *filePath = [skinPath stringByAppendingPathComponent:@"config.plist"];
    self.labelColorPlist = [[[NSDictionary alloc] initWithContentsOfFile:filePath] autorelease];
}

//限制当前对象创建多实例
#pragma mark - sengleton setting
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sigleton == nil) {
            sigleton = [super allocWithZone:zone];
        }
    }
    return sigleton;
}

+ (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;
}

- (oneway void)release {
}

- (id)autorelease {
    return self;
}

@end
