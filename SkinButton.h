//
//  SkinButton.h
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-25.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkinButton : UIButton

@property(nonatomic,copy)NSString *imageName;
@property(nonatomic,copy)NSString *highlightImageName;

@property(nonatomic,copy)NSString *backgroundImageName;
@property(nonatomic,copy)NSString *backgroundHighlightImageName;

- (id)initWithImageName:(NSString *)imageName highlight:(NSString *)highlightImageName;

- (id)initWithBackground:(NSString *)backgroundImageName highlightBackground:(NSString *)backgroundHighlightImageName;

@end
