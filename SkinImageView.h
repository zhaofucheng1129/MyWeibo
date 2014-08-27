//
//  SkinImageView.h
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-25.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkinImageView : UIImageView

@property(nonatomic,copy)NSString *imageName;
@property(nonatomic,assign)NSUInteger leftCapWidth;
@property(nonatomic,assign)NSUInteger topCapHeight;

- (id)initWithImageName:(NSString *)imageName;
@end
