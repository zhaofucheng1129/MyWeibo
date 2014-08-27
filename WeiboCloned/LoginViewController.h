//
//  LoginViewController.h
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-27.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController<UIScrollViewDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) UIPageControl *page;

- (void)loginButton:(UIButton *)sender;

@end
