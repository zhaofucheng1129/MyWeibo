//
//  StatusTableView.m
//  WeiboCloned
//
//  Created by ZhaoFucheng on 14-8-11.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "StatusTableView.h"
#import "StatusView.h"
#import "StatusTableViewCell.h"
#import "Status.h"

@implementation StatusTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - UITableView Delegate Methods
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    Status *status = [super.data objectAtIndex:indexPath.section];
    height = [StatusView getStatusViewHeight:status isRetweet:NO isDetail:NO];
    return height + 50;
}

#pragma mark - UITableView DataSourceDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"StatusCell";
    StatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[StatusTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
    }
    Status *status = [self.data objectAtIndex:indexPath.section];
    cell.statusData = status;
    
    return cell;
}

@end
