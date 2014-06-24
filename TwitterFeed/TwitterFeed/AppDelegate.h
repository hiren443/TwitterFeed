//
//  AppDelegate.h
//  TwitterFeed
//
//  Created by digi on 21/11/13.
//  Copyright (c) 2013 TechnoPote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterAdapter.h"
#import <Accounts/Accounts.h>
#import "TwitViewController.h"

extern CGFloat kCollectionFeedWidthPortrait;
extern CGFloat kCollectionFeedWidthLandscape;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

+(AppDelegate*)instance;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ACAccountStore *accountStore;

@property (strong, nonatomic) TwitterAdapter *twitterAdapter;
@property (strong, nonatomic) TwitViewController *viewController;

@property (strong, nonatomic) UINavigationController *feedNavigationController;
@property (strong, nonatomic) UINavigationController *twitterNavigationController;

-(void)accessTwitterAccount;

-(void)showError:(NSString*)errorMessage;

@end
