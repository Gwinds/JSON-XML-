//
//  ChinaWeatherTableViewController.h
//  天气预报
//
//  Created by doubi on 16/2/25.
//  Copyright © 2016年 doubi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityWeather.h"
@interface ChinaWeatherTableViewController : UITableViewController<NSXMLParserDelegate>
{
    NSMutableArray *citys;
    CityWeather *city;
    NSMutableDictionary *weatherImage;
}
-(void)refreshEvent:(UIRefreshControl*)sender;
@end
