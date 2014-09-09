//
//  HomeViewController.m
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-23.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "HomeViewController.h"
#import "UIFactory.h"
#import "SinaDataService.h"
#import "Status.h"
#import "StatusTableView.h"
#import "RootViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "RootViewController.h"
#import "DetailViewController.h"
#import "KxMenu.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *leftButton = [UIFactory createButton:@"navigationbar_friendsearch@2x.png" highlight:@"navigationbar_friendsearch_highlighted@2x.png"];
    [leftButton setFrame:CGRectMake(0, 0, 30, 30)];
    UIButton *rightButton = [UIFactory createButton:@"navigationbar_pop@2x.png" highlight:@"navigationbar_pop_highlighted@2x.png"];
    [rightButton setFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    [leftItem release];
    [rightItem release];
    
    if (CurrentVersion() < 7.0) {
        _height = 0;
    }
    else{
        _height = 65;
    }
    
    _tableView = [[StatusTableView alloc] initWithFrame:CGRectMake(0, _height, ScreenWidth, ScreenHeight - 44 - 20 - 45) style:UITableViewStyleGrouped];
    _tableView.eventDelegate = self;
    [self.view addSubview:_tableView];
    
    [self loadStatusDataWithSinceId:@"0" MaxId:@"0" Count:20];
}

- (void)showMenu:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"扫一扫"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"刷新"
                     image:nil
                    target:self
                    action:@selector(refreshLoading)],
      ];
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentLeft;
    
    [KxMenu showMenuInView:self.navigationController.view
                  fromRect:sender.frame
                 menuItems:menuItems];

}

- (void) pushMenuItem:(id)sender
{
    /*扫描二维码部分：
     导入ZBarSDK文件并引入一下框架
     AVFoundation.framework
     CoreMedia.framework
     CoreVideo.framework
     QuartzCore.framework
     libiconv.dylib
     引入头文件#import “ZBarSDK.h” 即可使用
     当找到条形码时，会执行代理方法
     
     - (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
     
     最后读取并显示了条形码的图片和内容。*/
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentViewController:reader animated:YES completion:^{
        
    }];
    [reader release];
}

#pragma mark - ZBarReaderDelegate Methods
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
//    imageview.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    [reader dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    //判断是否包含 头'http:'
    NSString *regex = @"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    //判断是否包含 头'ssid:'
    NSString *ssid = @"ssid+:[^\\s]*";;
    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
    
    NSString *contentString =  symbol.data;
    //处理部分中文乱码问题
    
    if ([contentString canBeConvertedToEncoding:NSShiftJISStringEncoding])
    {
        contentString = [NSString stringWithCString:[contentString cStringUsingEncoding:NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
    }
    
    NSLog(@"二维码信息：%@",contentString);
    
    if ([predicate evaluateWithObject:contentString]) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
                                                        message:contentString
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:@"Ok", nil];
        alert.delegate = self;
        alert.tag=1;
        [alert show];
        [alert release];
        
        
        
    }
    else if([ssidPre evaluateWithObject:contentString]){
        
        NSArray *arr = [contentString componentsSeparatedByString:@";"];
        
        NSArray * arrInfoHead = [[arr objectAtIndex:0] componentsSeparatedByString:@":"];
        
        NSArray * arrInfoFoot = [[arr objectAtIndex:1] componentsSeparatedByString:@":"];
        
        
        NSLog(@"二维码信息：%@",[NSString stringWithFormat:@"ssid: %@ \n password:%@",
                     [arrInfoHead objectAtIndex:1],[arrInfoFoot objectAtIndex:1]]);
        
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:contentString
                                                        message:@"The password is copied to the clipboard , it will be redirected to the network settings interface"
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:@"Ok", nil];
        
        
        alert.delegate = self;
        alert.tag=2;
        [alert show];
        [alert release];
        
        UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
        //        然后，可以使用如下代码来把一个字符串放置到剪贴板上：
        pasteboard.string = [arrInfoFoot objectAtIndex:1];
        
        
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showNewStatusCount:(NSInteger)count
{
    if (count > 0) {
        if (self.newStatusCountView == nil) {
            self.newStatusCountView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_new_status_background@2x.png"]] autorelease];
            self.newStatusCountView.frame = CGRectMake(0, _height - 35, ScreenWidth, 35);
            [self.view addSubview:self.newStatusCountView];
            
            UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            label.tag = 102;
            label.font = [UIFont systemFontOfSize:16.0f];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            [self.newStatusCountView addSubview:label];
        }
    
        UILabel *label = (UILabel *)[self.newStatusCountView viewWithTag:102];
        label.text = [NSString stringWithFormat:@"%d条新微薄",count];
        [label sizeToFit];
        label.origin = CGPointMake((self.newStatusCountView.width - label.width) / 2, (self.newStatusCountView.height - label.height) / 2);
        self.newStatusCountView.hidden = NO;
        [UIView animateWithDuration:0.6 animations:^{
            self.newStatusCountView.top = _height;
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.6 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.newStatusCountView.top = _height - 35;
                } completion:^(BOOL finished) {
                    self.newStatusCountView.hidden = YES;
                }];
            }
        }];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        SystemSoundID soundId;
        AudioServicesCreateSystemSoundID((CFURLRef)url, &soundId);
        AudioServicesPlayAlertSound(soundId);
    }
}

- (void)refreshLoading
{
    [self.tableView refreshLoading];
    [self pullDown:self.tableView];
}

#pragma mark - UITableViewEventDelegate Methods

- (void)pullDown:(BaseTableView *)tableView
{
    [self loadStatusDataWithSinceId:self.SinceId MaxId:@"0" Count:99];
}

- (void)pullUp:(BaseTableView *)tableView
{
    
}

- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    Status *status = [tableView.data objectAtIndex:indexPath.section];
    DetailViewController *detail = [[DetailViewController alloc] init];
    detail.statusData = status;
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}

#pragma mark - Network
//网络请求微博数据
-(void)loadStatusDataWithSinceId:(NSString *)sinceId MaxId:(NSString *)maxId Count:(NSInteger)count
{
    [SinaDataService getStatusDataWithSinceId:sinceId MaxId:maxId Count:count Page:1 BaseApp:0 Feature:0 TrimUser:0 Success:^(BOOL isSuccess, NSMutableArray *array) {
        if (isSuccess) {
            if (array.count > 0) {
                Status *status = [array firstObject];
                self.SinceId = status.idstr;
                status = [array lastObject];
                self.MaxId = status.idstr;
                
                if (![sinceId isEqualToString:@"0"] && [maxId isEqualToString:@"0"]) {
                    [self showNewStatusCount:array.count];
                    [array addObjectsFromArray:_tableView.data];
                    _tableView.data = array;
                }
                else if ([sinceId isEqualToString:@"0"] && ![maxId isEqualToString:@"0"]) {
                    [_tableView.data addObjectsFromArray:array];
                }
                else
                {
                    _tableView.data = array;
                }
            }
            
            [self.tableView reloadData];
            [self.tableView doneLoadingTableViewData];
            
            RootViewController *rootView = (RootViewController *)self.tabBarController;
            [rootView hiddenBadgeView];
        }
        else
        {
            NSLog(@"获取微博数据失败");
        }
    }];
}

- (void)dealloc {
    [_tableView release];
    [_newStatusCountView release];
    [_SinceId release];
    [_MaxId release];
    [super dealloc];
}
@end
