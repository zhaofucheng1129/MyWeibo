//
//  LocationSearch.m
//  WeiboCloned
//
//  Created by ZhaoFucheng on 14-9-4.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "LocationSearch.h"
#import "SinaDataService.h"
#import "UIImageView+WebCache.h"


@interface LocationSearch ()

@end

@implementation LocationSearch

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"我在这里";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"删除位置" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [rightBtn setFrame:CGRectMake(0, 0, 70, 30)];
    [rightBtn addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [leftBtn setFrame:CGRectMake(0, 0, 40, 30)];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [leftButton release];
    [rightButton release];
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
    }
    
    //地图
    self.mapView = [[[MKMapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)] autorelease];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.scrollEnabled = YES;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [_mapView release];
    
    //附近信息列表
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 200, ScreenWidth, self.view.height - 200) style:UITableViewStylePlain] autorelease];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    [_tableView release];
}

- (void)rightButtonAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)leftButtonAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)locationToLatitude:(CGFloat)latitude longitude:(CGFloat)longitude
{
    CLLocationCoordinate2D center = {latitude, longitude};
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    MKCoordinateRegion region = {center, span};
    [self.mapView setRegion:region animated:YES];
}

#pragma mark - MKMapViewDelegate Methods
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *annoId = @"annoId";
    MKPinAnnotationView *annoView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annoId];
    if (!annoView) {
        annoView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annoId] autorelease];
    }
    
    if ([((MKPointAnnotation *)annotation).subtitle isEqualToString:@"当前所在区域"]) {
        annoView.pinColor = MKPinAnnotationColorGreen;
    }
    
    annoView.canShowCallout = YES;
    return annoView;
}

#pragma mark - CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    CGFloat longitude = newLocation.coordinate.longitude;
    CGFloat latitude = newLocation.coordinate.latitude;
    
    if (self.locationData == nil) {
        
        [self locationToLatitude:latitude longitude:longitude];
        
        [SinaDataService getNearbyPoisWithLat:latitude Long:longitude range:2000 Q:@"" Category:@"" Count:20 Page:1 Sort:0 Offset:0 Success:^(BOOL isSuccess, NSDictionary *result) {
            if (isSuccess) {
                self.locationData = [result objectForKey:@"pois"];
                
                for (int i = 0; i < 5; i++) {
                    NSDictionary *loc = [self.locationData objectAtIndex:i];
                    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                    annotation.title = [loc objectForKey:@"title"];
                    if (!i) {
                        annotation.subtitle = @"当前所在区域";
                    }
                    else
                    {
                        annotation.subtitle = [loc objectForKey:@"address"];
                    }
                    CGFloat lat = [[loc objectForKey:@"lat"] floatValue];
                    CGFloat lon = [[loc objectForKey:@"lon"] floatValue];
                    CLLocationCoordinate2D coordinate = {lat, lon};
                    annotation.coordinate = coordinate;
                    [self.mapView addAnnotation:annotation];
                }
                
                [self.tableView reloadData];
            }
        }];
    }
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.locationData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
    }
    cell.textLabel.text = [[self.locationData objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.detailTextLabel.text = [[self.locationData objectAtIndex:indexPath.row] objectForKey:@"address"];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[[self.locationData objectAtIndex:indexPath.row] objectForKey:@"icon"]]];
    return cell;
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.block != nil) {
        NSDictionary *dic = [self.locationData objectAtIndex:indexPath.row];
        _block(dic);
        
        Block_release(_block);
        _block = nil;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_tableView release];
    [_locationData release];
    [_mapView release];
    [super dealloc];
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
