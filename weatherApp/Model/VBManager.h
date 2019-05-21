//
//  VBManager.h
//  weatherApp
//
//  Created by Admin on 18.05.19.
//  Copyright © 2019 bataevvlad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>
#import "VBCondition.h"

@import Foundation;
@import CoreLocation;

@interface VBManager : NSObject <CLLocationManagerDelegate>

//storing data, readonly - only manager can edit;
@property (strong, readonly, nonatomic) CLLocation  *currentLocation;
@property (strong, readonly, nonatomic) VBCondition *currentCondition;
@property (strong, readonly, nonatomic) NSArray *hourlyForecast;
@property (strong, readonly, nonatomic) NSArray *dailyForecast;

//will return appropriate type;
+(instancetype)sharedManager;

//starts and refresh;
-(void)findCurrentLocation;


@end
