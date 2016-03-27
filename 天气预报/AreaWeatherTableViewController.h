//
//  AreaWeatherTableViewController.h
//  天气预报
//
//  Created by doubi on 16/2/25.
//  Copyright © 2016年 doubi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityWeather.h"
#import "AreaWeather.h"
@interface AreaWeatherTableViewController : UITableViewController<NSXMLParserDelegate>
{

    NSMutableArray  *areas;
    AreaWeather  *area;
}
@property  (strong,nonatomic) NSMutableDictionary  *weatherImage;
@property  (strong,nonatomic) id   city;
@property  (assign,nonatomic) BOOL isCanForward;
@end
