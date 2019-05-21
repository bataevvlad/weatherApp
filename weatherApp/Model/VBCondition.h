//
//  VBCondition.h
//  weatherApp
//
//  Created by Admin on 18.05.19.
//  Copyright © 2019 bataevvlad. All rights reserved.
//

//#import "MTLModel.h"
#import <Mantle.h>

@interface VBCondition : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSNumber *humidity;
@property (strong, nonatomic) NSNumber *temperature;
@property (strong, nonatomic) NSNumber *tempHigh;
@property (strong, nonatomic) NSNumber *tempLow;
@property (strong, nonatomic) NSString *locationName;
@property (strong, nonatomic) NSDate *sunrise;
@property (strong, nonatomic) NSDate *sunset;
@property (strong, nonatomic) NSString *conditionDescription;
@property (strong, nonatomic) NSString *condition;
@property (strong, nonatomic) NSNumber *windBearing;
@property (strong, nonatomic) NSNumber *windSpeed;
@property (strong, nonatomic) NSString *icon;

- (NSString*) imageName;

@end
