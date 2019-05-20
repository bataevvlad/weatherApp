//
//  VBCondition.m
//  weatherApp
//
//  Created by Admin on 18.05.19.
//  Copyright © 2019 bataevvlad. All rights reserved.
//

#import "VBCondition.h"

@implementation VBCondition

+ (NSDictionary*)imageMap {
    
    static NSDictionary *_imageMap = nil;
    if (! _imageMap) {
        _imageMap = @{
                      @"01d" : @"weather-clear",
                      @"02d" : @"weather-few",
                      @"03d" : @"weather-few",
                      @"04d" : @"weather-broken",
                      @"09d" : @"weather-shower",
                      @"10d" : @"weather-rain",
                      @"11d" : @"weather-tstorm",
                      @"13d" : @"weather-snow",
                      @"50d" : @"weather-mist",
                      @"01n" : @"weather-moon",
                      @"02n" : @"weather-few-night",
                      @"03n" : @"weather-few-night",
                      @"04n" : @"weather-broken",
                      @"09n" : @"weather-shower",
                      @"10n" : @"weather-rain-night",
                      @"11n" : @"weather-tstorm",
                      @"13n" : @"weather-snow",
                      @"50n" : @"weather-mist",
                      };
    }
    return _imageMap;
}



+ (NSDictionary*) JSONKeyPathsByPropertyKey {
    return  @{
              @"date"         : @"dt",
              @"locationName" : @"name",
              //main;
              @"temperature"  : @"main.temp",
              @"humidity"     : @"main.humidity",
              @"tempLow"      : @"main.temp_min",
              @"tempHigh"     : @"main.temp_max",
              @"grndLevel"    : @"main.grnd_level",
              //wind;
              @"windDeg"      : @"wind.deg",
              @"windSpeed"    : @"wind.speed",
              //clouds;
              @"clouds"       : @"clouds.all",
              //rain;
              @"rain"         : @"rain.3h",
              //snow;
              @"snow"         : @"snow.3h",
              //weather;
              @"condDescription" : @"weather.description",
              @"condition"    : @"weather.main",
              @"icon"         : @"weather.icon",
              //sys;
              @"sunrise"      : @"sys.sunrise",
              @"sunset"       : @"sys.sunset",
              };
}

- (NSString*) imageName {
    
    
    
    
}

@end
