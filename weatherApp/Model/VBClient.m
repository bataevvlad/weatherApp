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

@end
