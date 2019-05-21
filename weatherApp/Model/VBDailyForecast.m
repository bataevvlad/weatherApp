//
//  VBDailyForecast.m
//  weatherApp
//
//  Created by Admin on 18.05.19.
//  Copyright © 2019 bataevvlad. All rights reserved.
//

#import "VBDailyForecast.h"

@implementation VBDailyForecast

+ (NSDictionary*) JSONKeyPathsByPropertyKey {
    //Create dict for storing;
    NSMutableDictionary *paths = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    //changing key maps;
    paths[@"tempHigh"] = @"temp.max";
    paths[@"temLow"]   = @"temp.min";
    
    return paths;
}

@end
