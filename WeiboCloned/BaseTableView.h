//
//  BaseTableView.h
//  WeiboCloned
//
//  Created by ZhaoFucheng on 14-8-11.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
@class BaseTableView;

@protocol UITableViewEventDelegate <NSObject>

@optional
- (void)pullDown:(BaseTableView *)tableView;
- (void)pullUp:(BaseTableView *)tableView;
- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BaseTableView : UITableView <EGORefreshTableHeaderDelegate,UITableViewDelegate, UITableViewDataSource>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _isReloading;
}

@property (nonatomic,assign) BOOL refreshHeader;    //是否需要下拉刷新

@property (nonatomic,retain) NSMutableArray *data;

@property (nonatomic, assign)id<UITableViewEventDelegate> eventDelegate;

- (void)doneLoadingTableViewData;

- (void)refreshLoading;

@end
