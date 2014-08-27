//
//  SkinLable.h
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-26.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkinLable : UILabel

@property(nonatomic,copy)NSString *labelName;

- (id)initWithLableName:(NSString *)labelName;

@end
