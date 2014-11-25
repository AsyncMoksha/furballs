//
//  GameManager.h
//  PAWS
//
//  Created by Joseph Crotchett on 10/13/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import <CoreData/CoreData.h>
#import <GameKit/GameKit.h>
#import "UserProfile.h"
#import "Card.h"
#import "Level.h"
#import "Item.h"
#import "Achievement.h"
#import "GameCenterManager.h"
#import "FBConnect.h"

#define kACHIEVEMENT_PRIMITIVE_STRIKE @"101"
#define kACHIEVEMENT_FLAWLESS_VICTORY @"102"
#define kACHIEVEMENT_FAT_CAT @"103"
#define kACHIEVEMENT_TOP_DOG @"104"
#define kACHEIVEMENT_BALLIN @"105"

typedef enum {
    CTCats = 0,
    CTDogs = 1
} CampaignType;

@interface GameManager : NSObject <GameCenterManagerDelegate, NSFetchedResultsControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    GameCenterManager *gameCenterManager;
    UserProfile *cats;
    UserProfile *dogs;
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
    CampaignType currentCampaign;
    
    //Facebook
	Facebook *facebook;
}

@property (retain, nonatomic) GameCenterManager *gameCenterManager;
@property (retain, nonatomic) UserProfile *cats;
@property (retain, nonatomic) UserProfile *dogs;
@property (assign, nonatomic) CampaignType currentCampaign;
@property (retain, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;	

@property (retain, nonatomic) Facebook *facebook;

-(void)fetchResults;
-(void)saveAllChanges;

//USER PROFILES
-(void)initDefaultUser;
-(UserProfile*)player;
-(UserProfile*)createNewUserProfileWithPlayerName:(NSString*)playerName andCampaignType:(CampaignType)campaign;
-(void)setLevelComplete:(NSInteger)levelID forCampaignType:(CampaignType)campaign;
-(void)setLevelCompleteForCurrentCampaign:(NSInteger)levelID;
-(NSArray*)getCompletedLevelsForCampaignType:(CampaignType)campaign;
-(NSArray*)getCompletedLevelsForCurrentCampign;
-(void)unlockCardWithUnitType:(NSInteger)unitType;
-(void)unlockItemWithItemType:(NSInteger)itemType;
-(void)addCoinsForBothCampaigns:(NSInteger)coinCount;
-(void)addCoinsForCurrentCampaign:(NSInteger)coinCount;

//IN APP PURCHASES
- (void)loadStore;
- (void)purchaseProduct:(NSString*)productID;
- (void)restorePreviousPurchases;
- (void)requestProductInformationWithProductID:(NSString*)prodID;
- (BOOL)canPurchaseProducts;
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful;
- (void)provideContent:(NSString *)productId;
- (void)recordTransaction:(SKPaymentTransaction *)transaction;
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response;
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void)failedTransaction:(SKPaymentTransaction *)transaction;
- (void)restoreTransaction:(SKPaymentTransaction *)transaction;
- (void)completeTransaction:(SKPaymentTransaction *)transaction;

//GAME CENTER FOR ACHIEVEMENTS AND LEADERBOARDS
+ (BOOL)isGameCenterAvailable;
- (void)authenticateUser;
- (void)processGameCenterAuth:(NSError*) error;
- (void)registerForAuthenticationNotification;
- (void)authenticationChanged;
- (void)updateAchievementWithID:(NSString*)aID withProgress:(double)aProgress;

@end
