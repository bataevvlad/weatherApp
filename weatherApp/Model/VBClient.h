//
//  VBClient.h
//  weatherApp
//
//  Created by Admin on 18.05.19.
//  Copyright © 2019 bataevvlad. All rights reserved.
//

@import CoreLocation;
#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface VBClient : NSObject

- (RACSignal*)fetchJSONFromURL:(NSURL*)url;
- (RACSignal*)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate;
- (RACSignal*)fetchHourlyForecastForLocation:(CLLocationCoordinate2D)coordinate;
- (RACSignal*)fetchDailyForecastForLocation:(CLLocationCoordinate2D)coordinate;


@end
