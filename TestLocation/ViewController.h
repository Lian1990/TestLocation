//
//  ViewController.h
//  TestLocation
//
//  Created by LIAN on 2017/4/24.
//  Copyright © 2017年 com.Alice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>

@property (strong,nonatomic) UITableView *myTable;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) NSMutableArray *dataArr;
@property (strong,nonatomic) NSTimer *myTimer;

@end

