//
//  MessageTableView.m
//  WeiboCloned
//
//  Created by ZhaoFucheng on 14-9-2.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "MessageTableView.h"

@implementation MessageTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}


#pragma mark - UITableView DataSource Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.textArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
    }
    cell.textLabel.text = [self.textArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[self.imageArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)dealloc
{
    [_textArray release];
    [_imageArray release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
