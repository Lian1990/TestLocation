//
//  ViewController.m
//  TestLocation
//
//  Created by LIAN on 2017/4/24.
//  Copyright © 2017年 com.Alice. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSString *_locationNewStr;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initDataTime];
    [self buildStage];
    [self startLoaction];
    
    [self buildLocalNotification];
}
-(void)initDataTime{
    self.dataArr = [[NSMutableArray alloc]init];
    NSDate *date = [NSDate date];
    NSString *dateStr = [NSString stringWithFormat:@"%@",date];
    [self.dataArr addObject:dateStr];
    NSLog(@"the time is %@",date);
}
#pragma mark === tableview ===
-(void)buildStage{
    self.myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.view addSubview:self.myTable];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text = [self.dataArr objectAtIndex:indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
#pragma mark === location ===
-(void)startLoaction{
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager setAllowsBackgroundLocationUpdates:YES];
        self.locationManager.pausesLocationUpdatesAutomatically = NO;//自动关闭定位更新
        self.locationManager.distanceFilter = 10.0f;
        [self.locationManager startUpdatingLocation];
    }
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([error code] == kCLErrorDenied) {
        NSLog(@"deny 拒绝访问");
    }else if ([error code] == kCLErrorLocationUnknown){
        NSLog(@"unkonwn location 定位未知");
    }else{
        return;
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *newloaction = [locations objectAtIndex:0];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:newloaction completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count>0) {
            CLPlacemark *place = [placemarks objectAtIndex:0];
            NSString *locationStr = place.subLocality;
            if (locationStr) {
                _locationNewStr = locationStr;
                if (self.myTimer == nil) {
                    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(updateLocationStr) userInfo:nil repeats:YES];
                }
                
            }
        }else if (error == nil && [placemarks count]==0){
            NSLog(@"无结果无结果 反编译没结果");
        }else if (error != nil){
            NSLog(@"the error is %@",error);
        }
    }];
    [manager stopUpdatingHeading];
}
-(void)updateLocationStr{
    NSString *str = [NSString stringWithFormat:@"%@+++%@",_locationNewStr,[NSDate date]];
    [self.dataArr insertObject:str atIndex:0];
    [self.myTable reloadData];
}
#pragma mark === 本地推送 ===
/**
 *  获获取当前客户端的逻辑日历
 *
 *  @return 当前客户端的逻辑日历
 */

+ (NSCalendar *) currentCalendar {
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar) {
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    }
    return sharedCalendar;
}
-(void)buildLocalNotification{
    UILocalNotification *localNotify = [[UILocalNotification alloc]init];
    if (localNotify != nil) {
//        localNotify.fireDate = [NSDate dateWithTimeIntervalSince1970:3*60*60];
//        localNotify.fireDate = [[NSDate date]dateByAddingTimeInterval:60];
        localNotify.fireDate = [NSDate dateWithTimeIntervalSinceNow:120];
        localNotify.repeatInterval = NSCalendarUnitHour;//时间间隔
        localNotify.timeZone = [NSTimeZone defaultTimeZone];
        localNotify.alertBody = @"打卡打卡打卡打卡！！！！！";
        localNotify.alertAction = @"test+test+test";
        localNotify.applicationIconBadgeNumber += 99;
        localNotify.soundName = UILocalNotificationDefaultSoundName;
//        localNotify.hasAction = NO;//app本地alert
        [[UIApplication sharedApplication]scheduleLocalNotification:localNotify];
    }
}
/**
 *  是不是周六日
 *
 *  @return YES 是 NO 不是
 */
//- (BOOL) isTypicallyWeekend {
//    NSDateComponents *components = [[NSDate currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
//    if ((components.weekday == 1) ||
//        (components.weekday == 7))
//        return YES;
//    return NO;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
