//
//  LoginViewController.m
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-27.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "LoginViewController.h"
#import "AuthorizeWebViewController.h"

@interface LoginViewController ()
{
    NSMutableArray *viewControllers;
    NSUInteger numberPages;
}
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        numberPages = 4;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numberPages, CGRectGetHeight(self.scrollView.frame));
    
    for (NSInteger i = 0; i < 4; i++) {
        UIImageView *imageView = nil;
        if (ScreenHeight == 480 || ScreenHeight == 960) {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"login_introduce_bg%d.jpg",i+1]]];
        }
        else if (ScreenHeight == 568)
        {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"login_introduce_bg%d-586h@2x.jpg",i+1]]];
        }
        [imageView setFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth, ScreenHeight)];
        [self.scrollView addSubview:imageView];
        [imageView release];
    }
    self.page = [[UIPageControl alloc] init];
    [self.page setNumberOfPages:numberPages];
    [self.page setFrame:CGRectMake(0, ScreenHeight - 120, ScreenWidth, 30)];
    [self.view addSubview:self.page];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(10, ScreenHeight - 80, 300, 30)];
    UIImage *normalImage = [UIImage imageNamed:@"login_button_big_orange@2x.png"];
    normalImage = [normalImage stretchableImageWithLeftCapWidth:3 topCapHeight:5];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    
    UIImage *highlightImage = [UIImage imageNamed:@"login_button_big_orange_highlighted@2x.png"];
    highlightImage = [highlightImage stretchableImageWithLeftCapWidth:3 topCapHeight:5];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [button setTitle:@"登陆" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loginButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginButton:(UIButton *)sender {
    AuthorizeWebViewController *authView = [[AuthorizeWebViewController alloc] init];
    [self presentViewController:authView animated:YES completion:^{
        
    }];
}

- (void)dealloc {
    [_page release];
    [_scrollView release];
    [super dealloc];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    NSUInteger page = floor((scrollView.contentOffset.x - pageWidth/2) / pageWidth) + 1;
    [self.page setCurrentPage:page];
}

@end
