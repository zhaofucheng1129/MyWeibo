//
//  RootViewController.h
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-23.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITabBarController <UINavigationControllerDelegate>
{
    UIView *_tabbarView;
    
    UIImageView *_sliderView;

    UIImageView *_badgeView;
}

- (void)hiddenBadgeView;

- (void)showTabbar:(BOOL)show;

@end
