//
//  UIFactory.h
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-25.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkinButton.h"
#import "SkinImageView.h"
#import "SkinLable.h"
@interface UIFactory : NSObject

+ (SkinButton *)createButton:(NSString *)imageName highlight:(NSString *)highlightImageName;
+ (SkinButton *)createButtonWithBackground:(NSString *)backgroundImageName backgroundHighlight:(NSString *)backgroundHighlightImageName;
+ (SkinImageView *)createImageView:(NSString *)imageName;
+ (SkinLable *)createLabel:(NSString *)labelName;
@end
