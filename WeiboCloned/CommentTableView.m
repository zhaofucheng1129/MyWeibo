//
//  CommentTableView.m
//  WeiboCloned
//
//  Created by ZhaoFucheng on 14-8-14.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "CommentTableView.h"
#import "CommentCell.h"

@implementation CommentTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - UITableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"CommentCellIdentify";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];
    }
    
    Comment *comment = [self.data objectAtIndex:indexPath.row];
    cell.commentData = comment;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *comment = [self.data objectAtIndex:indexPath.row];
    CGFloat height = [CommentCell getCommentHeight:comment];
    return height + 49;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 10)];
    commentLabel.backgroundColor = [UIColor clearColor];
    commentLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    commentLabel.textColor = [UIColor blackColor];
    commentLabel.text = [NSString stringWithFormat:@"评论 %@",self.statusData.comments_count];
    [commentLabel sizeToFit];
    [view addSubview:commentLabel];
    [commentLabel release];
    return [view autorelease];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
