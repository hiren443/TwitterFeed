//
//  TwitterAdapter.h
//  ADVNewsFeeder
//
//  Created by Tope on 10/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//
#define AccountTwitterAccessGranted @"TwitterAccessGranted"
#define AccountTwitterSelectedIdentifier @"TwitterAccountSelectedIdentifier"

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>

@interface TwitterAdapter : NSObject

@property (nonatomic, strong) ACAccount* account;

- (void)accessTwitterAccountWithAccountStore:(ACAccountStore*)accountStore;

- (void)refreshTwitterFeedWithCompletion:(void (^)(NSArray* jsonResponse))completion;

- (void)getTwitterProfileWithCompletion:(void (^)(NSDictionary* jsonResponse))completion;

@end
