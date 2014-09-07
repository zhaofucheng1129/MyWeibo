//
//  SendViewController.m
//  WeiboCloned
//
//  Created by ZhaoFucheng on 14-9-2.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "SendViewController.h"
#import "SinaDataService.h"
#import "LocationSearch.h"

@interface SendViewController ()
{
    UIButton *_rightBtn;
    UIButton *_localButton;
}
@end

@implementation SendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"发微博";
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initViews];
    
}

- (void)initViews
{
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    self.textView.scrollEnabled = NO;
//    self.textView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.textView];
    
    self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, ScreenWidth, 30)];
    self.buttonView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.buttonView];
    NSArray *imageNames = @[@"compose_toolbar_picture@2x.png",
                            @"compose_mentionbutton_background@2x.png",
                            @"compose_trendbutton_background@2x.png",
                            @"compose_emoticonbutton_background@2x.png",
                            @"message_add_background@2x.png"];
    NSArray *imageHighlightNames = @[@"compose_toolbar_picture_highlighted@2x.png",
                                     @"compose_mentionbutton_background_highlighted@2x.png",
                                     @"compose_trendbutton_background_highlighted@2x.png",
                                     @"compose_emoticonbutton_background_highlighted@2x.png",
                                     @"message_add_background_highlighted@2x.png"];
    for (int i = 0; i < imageNames.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:[imageNames objectAtIndex:i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[imageHighlightNames objectAtIndex:i]] forState:UIControlStateHighlighted];
        CGFloat width = ScreenWidth /imageNames.count;
        [button setFrame:CGRectMake(width * i + (width - 24) / 2, (self.buttonView.height - 24) / 2, 24, 24)];
        [self.buttonView addSubview:button];
    }
    [self.buttonView setFrame:CGRectMake(0, ScreenHeight - 30, ScreenWidth, 30)];
    [self.view addSubview:self.buttonView];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_rightBtn setFrame:CGRectMake(0, 0, 50, 30)];
    [_rightBtn addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [leftBtn setFrame:CGRectMake(0, 0, 50, 30)];
    [leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [leftButton release];
    [rightButton release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
    
    _localButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"compose_locatebutton_background_ready.png"];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 25, 0, 10);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    UIImage *imageHighlight = [UIImage imageNamed:@"compose_locatebutton_background_ready_highlighted.png"];
    imageHighlight = [imageHighlight resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    [_localButton setBackgroundImage:image forState:UIControlStateNormal];
    [_localButton setBackgroundImage:imageHighlight forState:UIControlStateHighlighted];
    [_localButton setFrame:CGRectMake(10, self.buttonView.top - 35, 80, 25)];
    [_localButton setTitle:@"插入位置" forState:UIControlStateNormal];
    _localButton.contentEdgeInsets = UIEdgeInsetsMake(5, 22, 5, 10);
    _localButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [_localButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_localButton addTarget:self action:@selector(locationSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_localButton];
    
    NSLog(@"%@",self.locationDictionary);
}

- (void)locationSearch:(UIButton *)sender
{
    LocationSearch *location = [[LocationSearch alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:location];
    [location release];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
    
    location.block = ^(NSDictionary *result) {
        _longitude = [[result objectForKey:@"lon"] floatValue];
        _latitude = [[result objectForKey:@"lat"] floatValue];
        
        NSString *address = [result objectForKey:@"address"];
        
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 25, 0, 10);
        [_localButton setBackgroundImage:[[UIImage imageNamed:@"compose_locatebutton_background_succeeded.png"] resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
        [_localButton setBackgroundImage:[[UIImage imageNamed:@"compose_locatebutton_background_succeeded_highlighted.png"] resizableImageWithCapInsets:insets] forState:UIControlStateHighlighted];
        CGSize titleSize = [address sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
        [_localButton setTitle:address forState:UIControlStateNormal];
        _localButton.width = titleSize.width + 35;
        if (_localButton.width > 300) {
            _localButton.width = 300;
        }
    };
}

- (void)showKeyBoard:(NSNotification *)notification
{
    NSValue *keyboardValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [keyboardValue CGRectValue];
    CGFloat height = frame.size.height;
    
    self.textView.height = ScreenHeight - 64 - height - 30;
    self.buttonView.bottom = ScreenHeight - height;
    _localButton.bottom = self.buttonView.top - 5;
}

- (void)closeKeyBoard:(NSNotification *)notification
{
    self.textView.height = ScreenHeight - 64 - 30;
    self.buttonView.bottom = ScreenHeight;
    _localButton.bottom = self.buttonView.top - 5;

}

- (void)leftButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)rightButtonAction:(id)sender
{
    [SinaDataService sendSimpleWeiboWithStatus:self.textView.text Visible:@"" ListId:@"" Lat:_latitude Long:_longitude Annotations:@"" Rip:@"" Success:^(BOOL isSuccess) {
        if (isSuccess) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            NSLog(@"发送成功!");
        }
        else
        {
            NSLog(@"发送失败!");
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
