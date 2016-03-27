//
//  CityWeather.h
//  天气预报
//
//  Created by doubi on 16/2/25.
//  Copyright © 2016年 doubi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityWeather : NSObject
@property (strong,nonatomic)NSString *quName,*pyName,*cityname,*state1,*state2,*stateDetailed,*tem1,*tem2,*windState;
-(NSString *)description;
@end
