//
//  VBClient.m
//  weatherApp
//
//  Created by Admin on 18.05.19.
//  Copyright © 2019 bataevvlad. All rights reserved.
//

#import "VBClient.h"
#import "VBCondition.h"
#import "VBDailyForecast.h"

@implementation VBClient

-(id) init {
    if (self == [super init]) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}

- (RACSignal *)fetchJSONFromURL:(NSURL *)url {
    NSLog(@"Fetching: %@",url.absoluteString);
    
    //returns signal;
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //fetching data from URL;
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            //Handle retrieved data
            if (!error) {
                NSError *jsonError = nil;
                //when JSON exiasts and there no errors;
                //send subscriber info;
                id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                if (!jsonError) {
                    //notify if error;
                    [subscriber sendNext:json];
                } else {
                    //notify if error;
                    [subscriber sendError:jsonError];
                }
            } else {
                [subscriber sendError:error];
            }
            [subscriber sendCompleted];
        }];
        
        //start network request;
        [dataTask resume];
        
        //cleanup;
        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
    }] doError:^(NSError *error) {
        //log error just in case;
        NSLog(@"%@",error);
    }];
}

//current conditions;
- (RACSignal*) fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate{
    //Format URL;
    NSString *urlString = [NSString stringWithFormat:@"api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=2b61358c47222923969614e819b3c483", coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];

    //create signal;
    return [[self fetchJSONFromURL:url] map:^id _Nullable(NSDictionary *json) {
        return [MTLJSONAdapter modelOfClass:[VBCondition class] fromJSONDictionary:json error:nil];
    }];
}

- (RACSignal*) fetchHourlyForecastForLoaction:(CLLocationCoordinate2D)coordinate {
    
    NSString *urlString = [NSString stringWithFormat:@"api.openweathermap.org/data/2.5/forecast/hourly?lat=%f&lon=%f&appid=2b61358c47222923969614e819b3c483", coordinate.latitude, coordinate.longitude];
    
    NSURL *url = [NSURL URLWithString:urlString];
    //reusing fetchJSON;
    return [[self fetchJSONFromURL:url] map:^id _Nullable(NSDictionary *json) {
        //perform reactivecocoa operation lists;
        RACSequence *list = [json[@"list"] rac_sequence];
        //new list of objects;
        return [[list map:^id _Nullable(NSDictionary *item) {
            //converting;
            return [MTLJSONAdapter modelOfClass:[VBCondition class] fromJSONDictionary:item error:nil];
            //get like array;
        }] array];
    }];
}

- (RACSignal*) fetchDailyForecastForLoaction:(CLLocationCoordinate2D)coordinate {
    
    NSString *urlString = [NSString stringWithFormat:@"api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&cnt=10&appid=2b61358c47222923969614e819b3c483", coordinate.latitude, coordinate.longitude];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    //usin fetch to convert;
    return [[self fetchJSONFromURL:url] map:^id _Nullable(NSDictionary *json) {
        //build sequense;
        RACSequence *list = [json[@"list"] rac_sequence];
        
        //USe func for mapping;
        return [[list map:^id _Nullable(NSDictionary *item) {
            return [MTLJSONAdapter modelOfClass:[VBDailyForecast class] fromJSONDictionary:item error:nil];
        }] array];
    }];
}


@end
