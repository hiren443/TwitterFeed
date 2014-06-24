//
//  TwitViewController.h
//  TwitterFeed
//
//  Created by digi on 21/11/13.
//  Copyright (c) 2013 TechnoPote. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSDictionary *profileDict;
    NSArray *feedAr;
}
@property (nonatomic, weak) IBOutlet UIImageView* profilePictureImageView;

@property (nonatomic, weak) IBOutlet UIImageView* bannerImageView;

@property (nonatomic, weak) IBOutlet UIView* profilePictureContainer;

@property (nonatomic, weak) IBOutlet UILabel* usernameLabel;

@property (nonatomic, weak) IBOutlet UILabel* screenNameLabel;

@property (nonatomic, weak) IBOutlet UILabel* followingCountLabel;

@property (nonatomic, weak) IBOutlet UILabel* followerCountLabel;

@property (nonatomic, weak) IBOutlet UILabel* followingLabel;

@property (nonatomic, weak) IBOutlet UILabel* followerLabel;

@property (nonatomic, weak) IBOutlet UIView* overlayView;

@property (nonatomic, weak) IBOutlet UIView* statsBarView;

@property (nonatomic, weak) IBOutlet UILabel* tweetLabel;

@property (nonatomic, weak) IBOutlet UILabel* dateLabel;

@property (nonatomic, weak) IBOutlet UIImageView* profileImageView;

@property (nonatomic, weak) IBOutlet UIView* profileImageContainer;

@property (nonatomic, weak) IBOutlet UIImageView* bgImageView;


@property (nonatomic, strong) IBOutlet UIImageView *profileImg;
@property (nonatomic, strong) IBOutlet UILabel *userNameLbl;
@property (nonatomic, strong) IBOutlet UITableView *feedTable;

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSNumber* followerCount;
@property (nonatomic, strong) NSNumber* followingCount;
@property (nonatomic, strong) NSNumber* twitterId;
@property (nonatomic, strong) NSString* screenName;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* profileImageUrl;
@property (nonatomic, strong) NSString* profileBannerUrl;



@end
