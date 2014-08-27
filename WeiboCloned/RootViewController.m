//
//  RootViewController.m
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-23.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "RootViewController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "ComposeViewController.h"
#import "DiscoverViewController.h"
#import "ProfileViewController.h"
#import "BaseNavigationController.h"

#import "SinaDataService.h"
#import "LoginViewController.h"

#import "UIFactory.h"
#import "SinaDataService.h"

@interface RootViewController ()

/**
 初始化子视图控制器
 */
-(void)_initSubViewController;

/**
 自定义Tabbar视图
 */
-(void)_initTabbarView;

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (CurrentVersion() >= 7.0) {
            [self.tabBar setHidden:YES];
        }
        else
        {
            [self hideTabBar:YES];
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([SinaDataService isAuthorized]) {
        [self _initSubViewController];
        [self _initTabbarView];
        
        //定时请求未读微博数量
        [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    }
    else
    {
        LoginViewController *loginView = [[LoginViewController alloc] init];
        self.viewControllers = @[loginView];
        [loginView release];
    }

}

//获取未读数数据
- (void)timerAction:(NSTimer *)timer
{
    [SinaDataService getStatusUnreadCountWithSuccess:^(BOOL isSuccess, NSDictionary *result) {
        if (isSuccess) {
            [self refreshUnReadView:result];
        }
    }];
}

//更新未读角标视图
- (void)refreshUnReadView:(NSDictionary *)result
{
    NSNumber *statusCount = [result objectForKey:@"status"];
    if (_badgeView == nil) {
        _badgeView = [UIFactory createImageView:@"main_badge@2x.png"];
        _badgeView.frame = CGRectMake(64 - 25, 4, 19, 19);
        [_tabbarView addSubview:_badgeView];
        
        UILabel *badgeLabel = [[UILabel alloc] initWithFrame:_badgeView.bounds];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.backgroundColor = [UIColor clearColor];
        badgeLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        badgeLabel.textColor = [UIColor whiteColor];
        badgeLabel.tag = 100;
        [_badgeView addSubview:badgeLabel];
        [badgeLabel release];
    }
    int count = [statusCount intValue];
    if (count > 0) {
        UILabel *badgeLabel = (UILabel *)[_badgeView viewWithTag:100];
        if (count > 99) {
            count = 99;
        }
        badgeLabel.text = [NSString stringWithFormat:@"%d",count];
        _badgeView.hidden = NO;
    }
    else
    {
        _badgeView.hidden = YES;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
/**
 初始化子视图控制器
 */
-(void)_initSubViewController
{
    HomeViewController *home = [[[HomeViewController alloc] init] autorelease];
    MessageViewController *message = [[[MessageViewController alloc] init] autorelease];
    ComposeViewController *compose = [[[ComposeViewController alloc] init] autorelease];
    DiscoverViewController *discover = [[[DiscoverViewController alloc] init] autorelease];
    ProfileViewController *profile = [[[ProfileViewController alloc] init] autorelease];
    
    NSArray *views = @[home,message,compose,discover,profile];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:5];
    for (UIViewController *viewController in views) {
        BaseNavigationController *navigation = [[BaseNavigationController alloc] initWithRootViewController:viewController];
        navigation.delegate = self;
        [viewControllers addObject:navigation];
        [navigation release];
    }
    self.viewControllers = viewControllers;
}

/**
 自定义Tabbar视图
 */
-(void)_initTabbarView
{
    _tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
    [self.view addSubview:_tabbarView];
    [_tabbarView release];
    
    UIImageView *tabbarImageView = [UIFactory createImageView:@"tabbar_background@2x.png"];
    
    tabbarImageView.frame = _tabbarView.bounds;
    [_tabbarView addSubview:tabbarImageView];

    
    NSArray *background = @[@"tabbar_home@2x.png",@"tabbar_message_center@2x.png",@"tabbar_compose_button@2x.png",@"tabbar_discover@2x.png",@"tabbar_profile@2x.png"];
    
    NSArray *highlight = @[@"tabbar_home_highlighted@2x.png",@"tabbar_message_center_highlighted@2x.png",@"tabbar_compose_button_highlighted@2x.png",@"tabbar_discover_highlighted@2x.png",@"tabbar_profile_highlighted@2x.png"];
    
//    NSArray *selected = @[@"tabbar_home_selected",@"tabbar_message_center_selected",@"",@"tabbar_discover_selected",@"tabbar_profile_selected"];
    
    for (NSInteger i = 0; i < background.count; i++) {
        NSString *backgroundName = [background objectAtIndex:i];
        NSString *highlightName = [highlight objectAtIndex:i];
        
        UIButton *button = [UIFactory createButton:backgroundName highlight:highlightName];
        button.tag = i;
        if (i == 2) {
            button.frame = CGRectMake((64-64)/2+i*64, (44-44)/2, 64, 44);
        }
        else
        {
            button.frame = CGRectMake((64-30)/2+i*64, (44-30)/2, 30, 30);
        }
        
        [button addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        
        [_tabbarView addSubview:button];
    }
    
    _sliderView = [UIFactory createImageView:@"tabbar_slider@2x.png"];
    [_sliderView setBackgroundColor:[UIColor clearColor]];
    [_sliderView setFrame:CGRectMake(0, 0, 64, 44)];
    [_tabbarView addSubview:_sliderView];
}

-(void)selectTab:(UIButton *)button
{
    if (button.tag != 2) {
        [UIView animateWithDuration:0.2 animations:^{
//            CGRect frame = self.sliderView.frame;
//            frame.origin.x = button.frame.origin.x;
//            self.sliderView.frame = frame;
            _sliderView.center = button.center;
        }];
        
        if (button.tag == self.selectedIndex && button.tag == 0) {
            UINavigationController *homeNav = [self.viewControllers firstObject];
            HomeViewController *homeCtrl = [homeNav.viewControllers firstObject];
            [homeCtrl refreshLoading];
        }
    }
    
    self.selectedIndex = button.tag;
}
//IOS6下隐藏TabBar
- (void) hideTabBar:(BOOL) hidden{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, ScreenHeight, view.frame.size.width, view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, ScreenHeight - 47, view.frame.size.width, view.frame.size.height)];
            }
        }
        else
        {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, ScreenHeight)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, ScreenHeight - 47)];
            }
        }
    }
    [UIView commitAnimations];
}

- (void)adjustView:(BOOL)showTabbar
{
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITransitionView")]) {
            if (showTabbar) {
                subView.height = ScreenHeight;
            }
            else
            {
                subView.height = ScreenHeight - 44 - 20 - 45;
            }
        }
    }
}

#pragma mark - UINavigationDelegate Method
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    int count = navigationController.viewControllers.count;
    if (count == 2) {
        [self showTabbar:NO];
    }
    else if (count == 1)
    {
        [self showTabbar:YES];
    }
}

#pragma mark - Custom Method

- (void)hiddenBadgeView
{
    _badgeView.hidden = YES;
}

- (void)showTabbar:(BOOL)show
{
    [UIView animateWithDuration:0.3 animations:^{
        if (show) {
            _tabbarView.left = 0;
        }
        else
        {
            _tabbarView.left = -ScreenWidth;
        }
    }];
    
    [self adjustView:show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
