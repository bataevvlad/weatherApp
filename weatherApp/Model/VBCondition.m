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

- (NSString*) imageName {
    return [VBCondition imageMap][self.icon];
}

+ (NSDictionary*) JSONKeyPathsByPropertyKey {
    return  @{
              @"date": @"dt",
              @"locationName": @"name",
              @"humidity": @"main.humidity",
              @"temperature": @"main.temp",
              @"tempHigh": @"main.temp_max",
              @"tempLow": @"main.temp_min",
              @"sunrise": @"sys.sunrise",
              @"sunset": @"sys.sunset",
              @"conditionDescription": @"weather",
              @"condition": @"weather",
              @"icon": @"weather",
              @"windBearing": @"wind.deg",
              @"windSpeed": @"wind.speed"
              };
}

//Converting data;
+ (NSValueTransformer *)dateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSDate dateWithTimeIntervalSince1970:value.floatValue];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
    }];
}

//sunriseTransform
+(NSValueTransformer*)sunriseJSONTransformer {
    return [self dateJSONTransformer];
}
//sunset trnsform;
+(NSValueTransformer*)sunsetJSONTransformer {
    return [self dateJSONTransformer];
}

+ (NSValueTransformer *)conditionDescriptionJSONTransformer {
    //+transformerUsingForwardBlock:reverseBlock:
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSArray *values, BOOL *success, NSError *__autoreleasing *error) {
        NSDictionary *weatherInfo = values.firstObject;
        return weatherInfo[@"description"];
    } reverseBlock:^(NSString *str, BOOL *success, NSError *__autoreleasing *error) {
        return @[@{@"condition":str}];
    }];
}

+ (NSValueTransformer*) conditionJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *values, BOOL *success, NSError *__autoreleasing *error) {
        NSDictionary *weatherInfo = values.firstObject;
        return weatherInfo[@"main"];
    } reverseBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
        return @[@{@"conditionDescription":string}];
    }];
}

+ (NSValueTransformer*) iconJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *values, BOOL *success, NSError *__autoreleasing *error) {
        NSDictionary *weatherInfo = values.firstObject;
        return weatherInfo[@"icon"];
    } reverseBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
        return @[@{@"icon":string}];
    }];
}

+ (NSValueTransformer *)temperatureJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *value, BOOL *success, NSError *__autoreleasing *error) {
        return @(value.floatValue - 273.15);
    }];
}

+ (NSValueTransformer *)tempHighJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *value, BOOL *success, NSError *__autoreleasing *error) {
        return @(value.floatValue - 273.15);
    }];
}

+ (NSValueTransformer *)tempLowJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *value, BOOL *success, NSError *__autoreleasing *error) {
        return @(value.floatValue - 273.15);
    }];
}

@end

