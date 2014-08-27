//
//  AuthorizeWebViewController.m
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-28.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "AuthorizeWebViewController.h"
#import "SinaDataService.h"
#import "RootViewController.h"

@interface AuthorizeWebViewController ()

@end

@implementation AuthorizeWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, CurrentVersion()>7.0?20:0, ScreenWidth, 44)];
    [self.view addSubview:navBar];
    [navBar release];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:UIColorMake(255, 130, 1, 1) forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button release];
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    [navItem setLeftBarButtonItem:leftItem];
    [leftItem release];
    [navBar pushNavigationItem:navItem animated:YES];
    [navItem release];    
    
    NSInteger y = CurrentVersion()>7.0?64:44;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, y, ScreenWidth, ScreenHeight - y)];
    [webView setDelegate:self];
    [self.view addSubview:webView];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[SinaDataService authorizeURL]];
    [webView loadRequest:request];
    [request release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString rangeOfString:@"code="].location != NSNotFound) {
        NSString *code = [[[request.URL query] componentsSeparatedByString:@"="] objectAtIndex:1];
        [SinaDataService getAccessToken:code success:^(BOOL isSuccess) {
            if (isSuccess) {
                RootViewController *rootView = [[RootViewController alloc] init];
                [[[[UIApplication sharedApplication] delegate] window] setRootViewController:rootView];
                [rootView release];
            }
            else
            {
                [webView reload];
            }
        }];
        return NO;
    }
    
    return YES;
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
