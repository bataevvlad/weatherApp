//
//  VBClient.h
//  weatherApp
//
//  Created by Admin on 18.05.19.
//  Copyright © 2019 bataevvlad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@import CoreLocation;
@import Foundation;

@interface VBClient : NSObject
@property (strong, nonatomic) NSURLSession *session;

- (RACSignal*)fetchJSONFromURL:(NSURL*)url;
- (RACSignal*)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate;
- (RACSignal*)fetchHourlyForecastForLoaction:(CLLocationCoordinate2D)coordinate;
- (RACSignal*)fetchDailyForecastForLoaction:(CLLocationCoordinate2D)coordinate;


@end
