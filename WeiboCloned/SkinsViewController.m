//
//  SkinsViewController.m
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-25.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "SkinsViewController.h"
#import "SkinsManager.h"
#import "UIFactory.h"
@interface SkinsViewController ()
{
    
}
@end

@implementation SkinsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        skins = [[SkinsManager shareInstance].skinsPlist allKeys];
        [skins retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return skins.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"skinCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
        UILabel *cellLabel = [UIFactory createLabel:kTableViewCellTextColor];
        [cellLabel setFrame:CGRectMake(10, 10, 200, 30)];
        [cellLabel setBackgroundColor:[UIColor clearColor]];
        [cellLabel setTag:2014];
        [cell.contentView addSubview:cellLabel];
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:2014];
    NSString *name = [skins objectAtIndex:indexPath.row];
    label.text = name;
    
    NSString *skinName = [[SkinsManager shareInstance] skinName];
    if ([skinName isEqualToString:name]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *skinName = [skins objectAtIndex:indexPath.row];
    [[SkinsManager shareInstance] setSkinName:skinName];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSkinDidChangeNotification object:skinName];
    
    [[NSUserDefaults standardUserDefaults] setObject:skinName forKey:kSkinName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [tableView reloadData];
}

@end
