//
//  ViewController.m
//  weatherApp
//
//  Created by Admin on 17.05.19.
//  Copyright © 2019 bataevvlad. All rights reserved.
//

#import "ViewController.h"
#import <DLBlurredImage/UIImageView+DLBlurredImage.h>
#import "VBManager.h"


static const CGFloat   inset = 20;
static const CGFloat   temperatureHeight = 110;
static const CGFloat   hiloHeight = 40;
static const CGFloat   iconHeight = 30;

@interface ViewController ()

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImageView *blurredImageView;
@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) CGFloat     screenHeight;
@property (assign, nonatomic) CGRect      headerFrame;

@property (strong, nonatomic) UIView  *header;
@property (strong, nonatomic) UILabel *temperatureLabel;
@property (strong, nonatomic) UILabel *hiloLabel;
@property (strong, nonatomic) UILabel *cityLabel;
@property (strong, nonatomic) UILabel *conditionsLabel;
@property (strong, nonatomic) UIImageView *iconView;

@property (assign, nonatomic) CGRect temperatureFrame;
@property (assign, nonatomic) CGRect iconFrame;

@property (strong, nonatomic) NSDateFormatter *hourlyFormatter;
@property (strong, nonatomic) NSDateFormatter *dailyFormatter;

@end

@implementation ViewController

- (id) init {
    if (self = [super init]) {
        
        self.hourlyFormatter = [[NSDateFormatter alloc] init];
        self.hourlyFormatter.dateFormat = @"h a";
        
        self.dailyFormatter = [[NSDateFormatter alloc] init];
        self.dailyFormatter.dateFormat = @"EEEE";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //Get and store screen height for future actions;
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    //add static image for the background;
    UIImage *backgroundOne = [UIImage imageNamed:@"Sun2.png"];
    
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:backgroundOne];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    //blurred image for background;
    self.blurredImageView = [[UIImageView alloc] init];
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredImageView.alpha = 0;
    [self.blurredImageView setImageToBlur:backgroundOne blurRadius:10 completionBlock:nil];
    [self.view addSubview:self.blurredImageView];
    
    //delegates manage;
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.tableView.pagingEnabled = YES;
    [self.view addSubview:self.tableView];
    
    self.headerFrame = [UIScreen mainScreen].bounds;

    self.header = [[UIView alloc] initWithFrame:self.headerFrame];
    self.header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.header;
    [self hiloOutput];
    [self temperatureOutput];
    [self iconOutput];
    [self conditionsOutput];
    [self cityLabelOutput];
    
////FOR TEST
//    CGRect headerFrame = [UIScreen mainScreen].bounds;
//    CGFloat inset = 20;
//    CGFloat temperatureHeight = 110;
//    CGFloat hiloHeight = 40;
//    CGFloat iconHeight = 30;
//    CGRect hiloFrame = CGRectMake(inset, headerFrame.size.height - hiloHeight, headerFrame.size.width - 2*inset, hiloHeight);
//    CGRect temperatureFrame = CGRectMake(inset, headerFrame.size.height - temperatureHeight - hiloHeight, headerFrame.size.width - 2*inset, temperatureHeight);
//    CGRect iconFrame = CGRectMake(inset, temperatureFrame.origin.y - iconHeight, iconHeight, iconHeight);
//    CGRect conditionsFrame = iconFrame;
//    // make the conditions text a little smaller than the view
//    // and to the right of our icon
//    conditionsFrame.size.width = self.view.bounds.size.width - 2*inset - iconHeight - 10;
//    conditionsFrame.origin.x = iconFrame.origin.x + iconHeight + 10;
//
//    UIView *header = [[UIView alloc] initWithFrame:headerFrame];
//    header.backgroundColor = [UIColor clearColor];
//    self.tableView.tableHeaderView = header;
//
//    // bottom left
//    UILabel *temperatureLabel = [[UILabel alloc] initWithFrame:temperatureFrame];
//    temperatureLabel.backgroundColor = [UIColor clearColor];
//    temperatureLabel.textColor = [UIColor whiteColor];
//    temperatureLabel.text = @"0°";
//    temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120];
//    [header addSubview:temperatureLabel];
//
//    // bottom left
//    UILabel *hiloLabel = [[UILabel alloc] initWithFrame:hiloFrame];
//    hiloLabel.backgroundColor = [UIColor clearColor];
//    hiloLabel.textColor = [UIColor whiteColor];
//    hiloLabel.text = @"0° / 0°";
//    hiloLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
//    [header addSubview:hiloLabel];
//
//    // top
//    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 30)];
//    cityLabel.backgroundColor = [UIColor clearColor];
//    cityLabel.textColor = [UIColor whiteColor];
//    cityLabel.text = @"Loading...";
//    cityLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
//    cityLabel.textAlignment = NSTextAlignmentCenter;
//    [header addSubview:cityLabel];
//
//    UILabel *conditionsLabel = [[UILabel alloc] initWithFrame:conditionsFrame];
//    conditionsLabel.backgroundColor = [UIColor clearColor];
//    conditionsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
//    conditionsLabel.textColor = [UIColor whiteColor];
//    [header addSubview:conditionsLabel];
//
//    // bottom left
//    UIImageView *iconView = [[UIImageView alloc] initWithFrame:iconFrame];
//    iconView.contentMode = UIViewContentModeScaleAspectFit;
//    iconView.backgroundColor = [UIColor clearColor];
//    [header addSubview:iconView];
////FOR TEST
    
    //returned value from the signal is assigned to the text key of the hiloLabel object
    RAC(self.hiloLabel, text) = [[RACSignal combineLatest:@[
                                                           //combine the signals and use the latest values for both
                                                           RACObserve([VBManager sharedManager], currentCondition.tempHigh),
                                                           RACObserve([VBManager sharedManager], currentCondition.tempLow)]
                                                           //reduce the values from your combined signals into a single value
                                                  reduce:^(NSNumber *hi, NSNumber *low) {
                                                      return [NSString  stringWithFormat:@"%.0f° / %.0f°",hi.floatValue,low.floatValue];
                                                  }]
                                 //deliver on main thread;
deliverOn:RACScheduler.mainThreadScheduler];
    
    //observers current condition;
    [[RACObserve([VBManager sharedManager], currentCondition)
      //updating on main thread;
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(VBCondition *newCondition) {
         //update labels;
         self.temperatureLabel.text = [NSString stringWithFormat:@"%.0f", newCondition.temperature.floatValue];
         self.conditionsLabel.text = [newCondition.condition capitalizedString];
         self.cityLabel.text = [newCondition.locationName capitalizedString];
         //using mapped image;
         self.iconView.image = [UIImage imageNamed:[newCondition imageName]];
        }];
    
    [[RACObserve([VBManager sharedManager], hourlyForecast)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSArray *newForecast) {
         [self.tableView reloadData];
     }];
    
    [[RACObserve([VBManager sharedManager], dailyForecast)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSArray *newForecast) {
         [self.tableView reloadData];
     }];

    [[VBManager sharedManager] findCurrentLocation];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
}

//Change color of our StatusBar;
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Frames & Margins

- (void) hiloOutput {
    
    CGRect hiloFrame = CGRectMake(inset,
                                  self.headerFrame.size.height - (3* hiloHeight),
                                  self.headerFrame.size.width + inset,
                                  hiloHeight);
    
    UILabel *hiloLabel = [[UILabel alloc] initWithFrame:hiloFrame];
    hiloLabel.backgroundColor = [UIColor clearColor];
    hiloLabel.textColor = [UIColor whiteColor];
    hiloLabel.text = @"0° / 0°";
    hiloLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    [self.header addSubview:hiloLabel];
}

- (void) temperatureOutput {
    
    self.temperatureFrame = CGRectMake(inset,
                                         self.headerFrame.size.height - (temperatureHeight + (3* hiloHeight)),
                                         self.headerFrame.size.width - (2 * inset),
                                         temperatureHeight);
    
    UILabel *temperatureLabel = [[UILabel alloc] initWithFrame:self.temperatureFrame];
    temperatureLabel.backgroundColor = [UIColor clearColor];
    temperatureLabel.textColor = [UIColor whiteColor];
    temperatureLabel.text = @"0°";
    temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120];
    [self.header addSubview:temperatureLabel];
}

- (void) iconOutput {
    
    self.iconFrame = CGRectMake(inset,
                                  self.temperatureFrame.origin.y - iconHeight,
                                  iconHeight,
                                  iconHeight);
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:self.iconFrame];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.backgroundColor = [UIColor clearColor];
    [self.header addSubview:iconView];
    //TODO icon;
}

-(void) conditionsOutput {
    
    CGRect conditionsFrame = self.iconFrame;
    conditionsFrame.size.width = self.view.bounds.size.width - (((2 * inset) + iconHeight) + 10);
    conditionsFrame.origin.x = self.iconFrame.origin.x + (iconHeight + 10);
    
    UILabel *conditionsLabel = [[UILabel alloc] initWithFrame:conditionsFrame];
    conditionsLabel.backgroundColor = [UIColor clearColor];
    conditionsLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:18];
    conditionsLabel.textColor = [UIColor whiteColor];
    [self.header addSubview:conditionsLabel];
}

- (void) cityLabelOutput {
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 30)];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.textColor = [UIColor whiteColor];
    cityLabel.text = @"One moment...";
    cityLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:25];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    [self.header addSubview:cityLabel];
}

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        //hourly forecast, adding 6 forecast + 1 for header;
        return MIN([[VBManager sharedManager].hourlyForecast count], 6) + 1;
    }
    //daily forecast, adding 6 forecast + 1 for header;
    return MIN([[VBManager sharedManager].dailyForecast count], 6) + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.section == 0) {
        // the first row of each section in header cell;
        if (indexPath.row == 0) {
            [self configureHeaderCell:cell title:@"Hourly forecast"];
        } else {
            //get hourly weather using custom methods;
            VBCondition *weather = [VBManager sharedManager].hourlyForecast[indexPath.row - 1];
            [self configureHourlyCell:cell weather:weather];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self configureHeaderCell:cell title:@"Daily Forecast"];
        } else {
            //get daily weather using custom method;
            VBCondition *weather = [VBManager sharedManager].dailyForecast[indexPath.row - 1];
            [self configureDailyCell:cell weather:weather];
        }
    }
    
    //Forecast cells shouldn’t be selectable.
    //Give them a semi-transparent black background and white text.
    
    return cell;
}

#pragma mark Cells configure

//configure and add text to cell as the header;
- (void)configureHeaderCell:(UITableViewCell*)cell title:(NSString*)title {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = @"";
    cell.imageView.image = nil;
}
//format for hourly format;
- (void)configureHourlyCell:(UITableViewCell*)cell weather:(VBCondition*)weather {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = [self.hourlyFormatter stringFromDate:weather.date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.f°", weather.temperature.floatValue];
    cell.imageView.image = [UIImage imageNamed:[weather imageName]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}
//format for daily format;
- (void)configureDailyCell:(UITableViewCell*)cell weather:(VBCondition*)weather {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = [self.dailyFormatter stringFromDate:weather.date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f° / %.0f°",
                                                            weather.tempHigh.floatValue,
                                                            weather.tempLow.floatValue];
    cell.imageView.image = [UIImage imageNamed:[weather imageName]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger cellCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    
    return self.screenHeight / (CGFloat)cellCount;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //get height of scrollview and offset;
    //cap offset at 0, to dont affect blurring;
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    
    //divide offset;
    CGFloat percent = MIN(position / height , 1.0);
    
    self.blurredImageView.alpha = percent;
}

@end
