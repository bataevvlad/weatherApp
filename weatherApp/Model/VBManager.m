//
//  VBManager.m
//  weatherApp
//
//  Created by Admin on 18.05.19.
//  Copyright © 2019 bataevvlad. All rights reserved.
//

#import "VBManager.h"
#import "VBClient.h"
#import <TSMessages/TSMessage.h>

@interface VBManager ()

//for change values privately;
@property (strong, readwrite, nonatomic) CLLocation  *currentLocation;
@property (strong, readwrite, nonatomic) VBCondition *currentCondition;
@property (strong, readwrite, nonatomic) NSArray *hourlyForecast;
@property (strong, readwrite, nonatomic) NSArray *dailyForecast;

//location finding and location data fetching;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) BOOL isFirstUpdate;
@property (strong, nonatomic) VBClient *client;

@end

@implementation VBManager

//singleton constructor;
+(instancetype)sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

-(id)init {
    if (self = [super init]) {
        //create location manager and set delegate;
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;

        //handle networking and data parsing;
        _client = [[VBClient alloc] init];

        //use macro to return signal (similar to KVO);
        //must not be nill;
        [[[[RACObserve(self, currentLocation) ignore:nil]

        //subscr to all signals;
    flattenMap:^(CLLocation *newLoaction) {
        return [RACSignal merge:@[
                                  [self updateCurrentConditions],
                                  [self updateDailyForecast],
                                  [self updateHourlyForecast],
                                  ]];
        //derive subcr on main thread;
    }] deliverOn:RACScheduler.mainThreadScheduler]
         //if error, log it;
    subscribeError:^(NSError * _Nullable error) {
        [TSMessage showNotificationWithTitle:@"Error" subtitle:@"There was a problem due last update" type:TSMessageNotificationTypeError];
    }];
    }
    return self;
}

#pragma mark Location

- (void)findCurrentLocation {
    self.isFirstUpdate = YES;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    //ignoring first loaction;
    //it always cached;
    if (self.isFirstUpdate) {
        self.isFirstUpdate = NO;
        return;
    }
    
    CLLocation *location = [locations lastObject];
    
    //stop updates when proper accuracy;
    if (location.horizontalAccuracy > 0) {
        //setting key triggers;
        self.currentLocation = location;
        [self.locationManager stopUpdatingLocation];
    }
}

#pragma mark Condition Updates

- (RACSignal*)updateCurrentConditions {
    return [[self.client fetchCurrentConditionsForLocation:self.currentLocation.coordinate] doNext:^(VBCondition *condition) {
        self.currentCondition = condition;
    }];
}

- (RACSignal*) updateHourlyForecast {
    return [[self.client fetchHourlyForecastForLoaction:self.currentLocation.coordinate] doNext:^(NSArray *conditions) {
        self.hourlyForecast = conditions;
    }];
}

- (RACSignal*) updateDailyForecast {
    return [[self.client fetchDailyForecastForLoaction:self.currentLocation.coordinate] doNext:^(NSArray *conditions) {
        self.dailyForecast = conditions;
    }];
}


@end
