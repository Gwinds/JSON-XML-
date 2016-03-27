//
//  CityWeather.m
//  天气预报
//
//  Created by doubi on 16/2/25.
//  Copyright © 2016年 doubi. All rights reserved.
//

#import "CityWeather.h"

@implementation CityWeather
-(NSString*)description
{
    return [NSString stringWithFormat:@"%@:%@ %@度--%@度 风向:%@",_cityname,_stateDetailed,_tem1,_tem2,_windState];
}
@end
