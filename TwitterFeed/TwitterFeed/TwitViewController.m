//
//  TwitViewController.m
//  TwitterFeed
//
//  Created by TechnoPote on 21/11/13.
//  Copyright (c) 2013 TechnoPote. All rights reserved.
//

#import "TwitViewController.h"
#import "AppDelegate.h"
#import "Utils.h"

#define kTwitterProfileImageKey @"user_profile_image"
#define kTwitterBannerImageKey @"user_banner_image"


#define kFacebookProfileImageKey @"user_profile_image"
#define kFacebookBannerImageKey @"user_banner_image"

#define kFacebookProfileTypePage @"Page"
#define kFacebookProfileTypePersonal @"Personal"

CGFloat kCollectionFeedWidthPortrait = 360;
CGFloat kCollectionFeedWidthLandscape = 320;

@interface TwitViewController ()
@property (strong, atomic) NSArray *tweets;

@property (strong, atomic) NSMutableDictionary *imagesDictionary;

@property (nonatomic, strong) NSDate *startRefreshDate;



@end

@implementation TwitViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = @"Twitter";
    self.navigationItem.titleView = titleLabel;
    self.tweets = [NSArray array];
    self.imagesDictionary = [NSMutableDictionary dictionary];
    
    CGFloat width = kCollectionFeedWidthPortrait;
    NSInteger colCount = 2;
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(20, 12, 20, 12);
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        width = kCollectionFeedWidthLandscape;
        colCount = 3;
        sectionInset = UIEdgeInsetsMake(20, 10, 20, 10);
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTwitterData) name:AccountTwitterAccessGranted object:nil];
    
    TwitterAdapter* twitterAdapter = [AppDelegate instance].twitterAdapter;
    [twitterAdapter accessTwitterAccountWithAccountStore:[AppDelegate instance].accountStore];
    
}


- (void)loadTwitterData {
    self.startRefreshDate = [NSDate date];
    [self getTwitterProfile];
    [self refreshTwitterFeed];
}

- (void)refreshTwitterFeed {
    TwitterAdapter* twitterAdapter = [AppDelegate instance].twitterAdapter;
    
    [twitterAdapter refreshTwitterFeedWithCompletion:^(NSArray* jsonResponse) {
        [self twitterFeedRefreshed:jsonResponse];
    }];
    
}
- (void)twitterFeedRefreshed:(NSArray*)jsonResponse {
    self.tweets = jsonResponse;
    
    NSLog(@"Tweets %@", self.tweets);
    [self.feedTable reloadData];
    
    
}

- (void)getTwitterProfile {
    if(profileDict.count == 0){
        TwitterAdapter* twitterAdapter = [AppDelegate instance].twitterAdapter;
        [twitterAdapter getTwitterProfileWithCompletion:^(NSDictionary* jsonResponse) {
            [self twitterProfileReceived:jsonResponse];
        }];
    }
}


-(void)twitterProfileReceived:(NSDictionary*)jsonObject{
    profileDict = [NSDictionary dictionaryWithDictionary:jsonObject];
    NSLog(@"Response %@", jsonObject);
    self.usernameLabel.text = [jsonObject objectForKey:@"name"];
    self.userNameLbl.text = [jsonObject objectForKey:@"screen_name"];
    self.followerCountLabel.text = [NSString stringWithFormat:@"%@",[jsonObject objectForKey:@"followers_count"]];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%@",[jsonObject objectForKey:@"friends_count"]];
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@",[jsonObject objectForKey:@"screen_name"]];
    self.url = [jsonObject objectForKey:@"url"];
    
    //Get larger Twitter Profile image
    //Ref: https://dev.twitter.com/docs/user-profile-images-and-banners
    
    self.profileImageUrl = [jsonObject objectForKey:@"profile_image_url"];
    self.profileImageUrl = [self.profileImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
    
    self.profileBannerUrl = [jsonObject objectForKey:@"profile_banner_url"];
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        self.profileBannerUrl = [self.profileBannerUrl stringByAppendingString:@"/mobile_retina"];
    } else {
        self.profileBannerUrl = [self.profileBannerUrl stringByAppendingString:@"/mobile"];
    }
    
    if (self.imagesDictionary[kTwitterProfileImageKey]) {
        self.profileImg.image = self.imagesDictionary[kTwitterProfileImageKey];
    } else {
        [self getImageFromUrl:self.profileImageUrl asynchronouslyForImageView:self.profileImg andKey:kTwitterProfileImageKey];
        
        [self getImageFromUrl:self.profileBannerUrl asynchronouslyForImageView:self.profileImg andKey:kTwitterBannerImageKey];
    }
    /*    self.profile = [[TwitterProfile alloc] initWithJSON:jsonResponse];
     
     [_profileView.usernameLabel setText:self.profile.name];
     [_profileView.followerCountLabel setText:[self.profile.followerCount stringValue]];
     [_profileView.followingCountLabel setText:[self.profile.followingCount stringValue]];
     [_profileView.screenNameLabel setText:[NSString stringWithFormat:@"@%@", self.profile.screenName]];
     
     if (self.imagesDictionary[kTwitterProfileImageKey]) {
     _profileView.profilePictureImageView.image = self.imagesDictionary[kTwitterProfileImageKey];
     } else {
     [self getImageFromUrl:self.profile.profileImageUrl asynchronouslyForImageView:_profileView.profilePictureImageView andKey:kTwitterProfileImageKey];
     
     [self getImageFromUrl:self.profile.profileBannerUrl asynchronouslyForImageView:_profileView.bannerImageView andKey:kTwitterBannerImageKey];
     }*/
}

#pragma mark -
#pragma mmark - tableview delegates

- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell=[[[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil] objectAtIndex:0];

    }
    
    NSDictionary *tweetDictionary = self.tweets[indexPath.row];
    
    NSDictionary *user = tweetDictionary[@"user"];
    
    UIImageView *bgImageView = (UIImageView *)[cell viewWithTag:10];
    UIImageView *profileImageView = (UIImageView *)[cell viewWithTag:12];
    UILabel *usernameLabel = (UILabel *)[cell viewWithTag:14];
    UILabel *tweetLabel = (UILabel *)[cell viewWithTag:15];
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:13];
    
    usernameLabel.text = user[@"name"];
    tweetLabel.text = tweetDictionary[@"text"];
    
    tweetLabel.frame =
    CGRectMake(tweetLabel.frame.origin.x,
               tweetLabel.frame.origin.y,
               320 - 84,
               [self heightForCellAtIndex:indexPath.row]-50);
    tweetLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    tweetLabel.font = [UIFont systemFontOfSize:13.0f];
    
    NSString *userName = user[@"name"];
    profileImageView.image = nil;
    
    if (self.imagesDictionary[userName]) {
        profileImageView.image = self.imagesDictionary[userName];
    } else {
        NSString* imageUrl = [user objectForKey:@"profile_image_url"];
        
        [self getImageFromUrl:imageUrl asynchronouslyForImageView:profileImageView andKey:userName];
    }
    
    NSArray *days = [NSArray arrayWithObjects:@"Mon ", @"Tue ", @"Wed ", @"Thu ", @"Fri ", @"Sat ", @"Sun ", nil];
    NSArray *calendarMonths = [NSArray arrayWithObjects:@"Jan", @"Feb", @"Mar",@"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
    NSString *dateStr = [tweetDictionary objectForKey:@"created_at"];
    
    for (NSString *day in days) {
        if ([dateStr rangeOfString:day].location == 0) {
            dateStr = [dateStr stringByReplacingOccurrencesOfString:day withString:@""];
            break;
        }
    }
    
    NSArray *dateArray = [dateStr componentsSeparatedByString:@" "];
    NSArray *hourArray = [[dateArray objectAtIndex:2] componentsSeparatedByString:@":"];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    NSString *aux = [dateArray objectAtIndex:0];
    int month = 0;
    for (NSString *m in calendarMonths) {
        month++;
        if ([m isEqualToString:aux]) {
            break;
        }
    }
    components.month = month;
    components.day = [[dateArray objectAtIndex:1] intValue];
    components.hour = [[hourArray objectAtIndex:0] intValue];
    components.minute = [[hourArray objectAtIndex:1] intValue];
    components.second = [[hourArray objectAtIndex:2] intValue];
    components.year = [[dateArray objectAtIndex:4] intValue];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneForSecondsFromGMT:2];
    [components setTimeZone:gmt];
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [calendar dateFromComponents:components];
    
    dateLabel.text = [Utils getTimeAsString:date];
    
    return cell;
}

- (CGFloat)heightForCellAtIndex:(NSUInteger)index {
    
    NSDictionary *tweet = self.tweets[index];
    CGFloat cellHeight = 55;
    NSString *tweetText = tweet[@"text"];
    
    CGFloat width = kCollectionFeedWidthPortrait;
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        width = kCollectionFeedWidthLandscape;
    }
    CGSize labelHeight = [tweetText sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(width - 84, 4000)];
    
    cellHeight += labelHeight.height;
    return cellHeight;
}


-(void)getImageFromUrl:(NSString*)imageUrl asynchronouslyForImageView:(UIImageView*)imageView andKey:(NSString*)key{
    
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *url = [NSURL URLWithString:imageUrl];
        
        __block NSData *imageData;
        
        dispatch_sync(dispatch_get_global_queue(
                                                DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            imageData =[NSData dataWithContentsOfURL:url];
            
            if(imageData){
                
                [self.imagesDictionary setObject:[UIImage imageWithData:imageData] forKey:key];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    imageView.image = self.imagesDictionary[key];
                });
            }
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
