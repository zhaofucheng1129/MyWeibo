//
//  LocationSearch.h
//  WeiboCloned
//
//  Created by ZhaoFucheng on 14-9-4.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

typedef void(^SelectedBlock)(NSDictionary *result);

@interface LocationSearch : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,MKMapViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *locationData;
@property (nonatomic, copy) SelectedBlock block;
@property (nonatomic, retain) MKMapView *mapView;
@end
