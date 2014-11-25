//
//  GameManager.m
//  PAWS
//
//  Created by Joseph Crotchett on 10/13/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "GameManager.h"

@implementation GameManager

@synthesize gameCenterManager;
@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize dogs;
@synthesize cats;
@synthesize currentCampaign;
@synthesize facebook;

-(void)initDefaultUser
{
	[self fetchResults];
	NSArray *users = [fetchedResultsController fetchedObjects];
	for(NSManagedObject *obj in users)
	{
		UserProfile *profile = (UserProfile*)obj;
		if([[profile name] isEqualToString:@"cats"])
		{
			[self setCats:profile];
			break;
		}
        else if([[profile name] isEqualToString:@"dogs"])
        {
            [self setDogs:profile];
            break;
        }
	}
	
    //If this is the first time the game is run, create the user profiles
	if(![self cats] || ![self dogs])
	{
		UserProfile *newCatsProfile = [self createNewUserProfileWithPlayerName:@"cats" andCampaignType:CTCats];
		[self setCats:newCatsProfile];
        
        UserProfile *newDogsProfile = [self createNewUserProfileWithPlayerName:@"dogs" andCampaignType:CTDogs];
		[self setDogs:newDogsProfile];
	}
}

-(UserProfile*)player
{
    return (currentCampaign == CTCats) ? cats : dogs;
}

- (UserProfile*)createNewUserProfileWithPlayerName:(NSString*)playerName andCampaignType:(CampaignType)campaign
{
    NSString *startingCardsPath = [[NSBundle mainBundle] pathForResource:@"StartingCards" ofType:@"plist"];
	NSDictionary *startingCardsContent = [NSMutableDictionary dictionaryWithContentsOfFile:startingCardsPath];
    
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"UserProfile" inManagedObjectContext:managedObjectContext];
    UserProfile *newUserProfile = (UserProfile*)newManagedObject;
	[newUserProfile setCoins:[NSNumber numberWithInt:0]];
    [newUserProfile setAttackSpeedLevel:[NSNumber numberWithInt:0]];
    [newUserProfile setAttackDamageLevel:[NSNumber numberWithInt:0]];
    [newUserProfile setMovementSpeedLevel:[NSNumber numberWithInt:0]];
    [newUserProfile setHitPointLevel:[NSNumber numberWithInt:0]];
    [newUserProfile setSpawnRateLevel:[NSNumber numberWithInt:0]];
    [newUserProfile setCoins:[NSNumber numberWithInt:0]];
    [newUserProfile setCampaign:[NSNumber numberWithInt:(int)campaign]];
    [newUserProfile setName:playerName];
    
    //Populate the Player Profile with starting units
    NSArray *cardsList;
    if(campaign == CTCats)
       cardsList = [startingCardsContent objectForKey:@"Cats"];
    else if(campaign == CTDogs)
        cardsList = [startingCardsContent objectForKey:@"Dogs"];
    
    //Populate the DB with the starting player cards
	for(NSDictionary *cardData in cardsList)
    {
        //Create the Achievement object
        NSManagedObject *cardManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:managedObjectContext];	
        Card *card = (Card*)cardManagedObject;
        [card setUnitType:[cardData objectForKey:@"Unit Type"]];
        [card setUserProfile:newUserProfile];
        [newUserProfile addCardsObject:card];
    }
    
    //Populate the DB with the achievement content
    NSString *AchievementsPath = [[NSBundle mainBundle] pathForResource:@"Achievements" ofType:@"plist"];
	NSDictionary *AchievementContent = [NSMutableDictionary dictionaryWithContentsOfFile:AchievementsPath];
	NSArray *achievements = [AchievementContent objectForKey:@"Achievements"];
	for(NSDictionary *achievementContent in achievements)
	{
		//Create the Achievement object
		NSManagedObject *achievementManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Achievement" inManagedObjectContext:managedObjectContext];	
		Achievement *achievement = (Achievement*)achievementManagedObject;
		[achievement setAchievementName:[achievementContent objectForKey:@"AchievementName"]];
		[achievement setAchievementID:[achievementContent objectForKey:@"AchievementID"]];
		[achievement setAchievementPercentCompleted:[achievementContent objectForKey:@"AchievementPercentCompleted"]];
		[achievement setAchievedDescription:[achievementContent objectForKey:@"AchievedDescription"]];
		[achievement setAchievementLetterIndex:[achievementContent objectForKey:@"AchievementLetterIndex"]];
		[achievement setUnachievedDescription:[achievementContent objectForKey:@"UnachievedDescription"]];
		[achievement setUserProfile:newUserProfile];
	}
    
    NSError *error = nil;
	if (![managedObjectContext save:&error]) 
	{
		NSLog(@"Core Data Save Error: %@, %@", error, [error userInfo]);
		abort();
	}
    
    return newUserProfile;
}

-(void)setLevelComplete:(NSInteger)levelID forCampaignType:(CampaignType)campaign
{
    //Create the Achievement object
    NSManagedObject *levelManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Level" inManagedObjectContext:managedObjectContext];	
    Level *level = (Level*)levelManagedObject;
    [level setLevelID:[NSNumber numberWithInt:levelID]];
    [level setUserProfile:((campaign == CTCats) ? cats : dogs)];
}

-(void)setLevelCompleteForCurrentCampaign:(NSInteger)levelID
{
    //Create the Achievement object
    NSManagedObject *levelManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Level" inManagedObjectContext:managedObjectContext];	
    Level *level = (Level*)levelManagedObject;
    [level setLevelID:[NSNumber numberWithInt:levelID]];
    [level setUserProfile:[self player]];
}

-(NSArray*)getCompletedLevelsForCampaignType:(CampaignType)campaign
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"levelID" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    UserProfile *profile = (campaign == CTCats) ? cats : dogs;
    NSArray *result = [[profile levels] sortedArrayUsingDescriptors:sortDescriptors];
    
    [sortDescriptor release];
    [sortDescriptors release];
    return result;    
}

-(NSArray*)getCompletedLevelsForCurrentCampign;
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"levelID" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    NSArray *result = [[[self player] levels] sortedArrayUsingDescriptors:sortDescriptors];
    
    [sortDescriptor release];
    [sortDescriptors release];
    return result;    
}

-(void)unlockCardWithUnitType:(NSInteger)unitType
{
    //Create the Achievement object
    NSManagedObject *cardManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:managedObjectContext];	
    Card *card = (Card*)cardManagedObject;
    [card setUnitType:[NSNumber numberWithInt:unitType]];
    [card setUserProfile:[self player]];
    [[self player] addCardsObject:card];
}

-(void)unlockItemWithItemType:(NSInteger)itemType
{
    //Create the Achievement object
    NSManagedObject *itemManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];	
    Item *item = (Item*)itemManagedObject;
    [item setItemType:[NSNumber numberWithInt:itemType]];
    [item setUserProfile:[self player]];
    [[self player] addItemsObject:item];
    
}

-(void)addCoinsForBothCampaigns:(NSInteger)coinCount
{
    NSInteger currentCoinCount = [[[self cats] coins] integerValue];
    currentCoinCount += coinCount;
    [[self cats] setCoins:[NSNumber numberWithInteger:currentCoinCount]];
    
    currentCoinCount = [[[self dogs] coins] integerValue];
    currentCoinCount += coinCount;
    [[self dogs] setCoins:[NSNumber numberWithInteger:currentCoinCount]];
}

-(void)addCoinsForCurrentCampaign:(NSInteger)coinCount
{
    NSInteger currentCoinCount = [[[self player] coins] integerValue];
    currentCoinCount += coinCount;
    [[self player] setCoins:[NSNumber numberWithInteger:currentCoinCount]];
}

#pragma mark -
#pragma mark Achievements

- (void) updateAchievementWithID:(NSString*)aID withProgress:(double)aProgress
{
	//Update the local copy
	NSInteger iAchievementID = [aID intValue];
	Achievement *achievementToUpdate = [[self player] getAchievementByID:iAchievementID];
    
    if(!achievementToUpdate)
        return;
    
	[achievementToUpdate setAchievementPercentCompleted:[NSNumber numberWithDouble:aProgress]];
	[self saveAllChanges];
	
	//If the percent has been updated to 100%, display the model view if the VC isn't nil
	if(aProgress >= 100.0)
	{
        //Display Achievement Earned Scene/Layer
	}
	
	//Report the progress to Game Center. 
	if(![GKLocalPlayer localPlayer])
		return;
	
	GKAchievement *achievement = [[[GKAchievement alloc] initWithIdentifier:aID] autorelease];
    if (achievement)
    {
		achievement.percentComplete = aProgress;
		[achievement reportAchievementWithCompletionHandler:^(NSError *error)
		 {
			 if (error != nil)
			 {
				 NSLog(@"%@", [error localizedDescription]);
			 }
			 else 
			 {
				 NSLog(@"achievement reported to game center successfully");
			 }
             
		 }];
    }
}


- (void)saveAllChanges
{
	// Save the context.
	NSError *error = nil;
	if (![managedObjectContext save:&error]) 
	{
		NSLog(@"Core Data Save Error: %@, %@", error, [error userInfo]);
		abort();
	}
}

#pragma mark -
#pragma mark Fetched results controller

-(void)fetchResults
{	
	NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) 
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserProfile" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    return fetchedResultsController;
} 

#pragma mark -
#pragma mark In App Purchase API for Game Manager 
- (void) loadStore
{
	// restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void) purchaseProduct:(NSString*)productID
{
	SKPayment *payment = [SKPayment paymentWithProductIdentifier:productID];
    [[SKPaymentQueue defaultQueue] addPayment:payment];	
}

- (void) requestProductInformationWithProductID:(NSString*)prodID
{
	SKProductsRequest *request = [[[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:prodID]]autorelease];
	
	[request setDelegate:self];
	[request start];
}

- (BOOL) canPurchaseProducts
{
	return [SKPaymentQueue canMakePayments];
}

- (void) restorePreviousPurchases
{
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    /*	NSArray *myProducts = [response products];
     NSArray *invalid = [response invalidProductIdentifiers];
     
     for(SKProduct *product in myProducts)
     NSLog(@"Name: %@, Price: %f, Description: %@", [product localizedTitle], [[product price] doubleValue], [product localizedDescription]);
     
     for(NSString *prodID in invalid)
     NSLog(@"Invalid Product ID: %@", prodID);*/
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver Methods

- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction *transaction in transactions)
	{
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
				[self completeTransaction:transaction];
				break;
			case SKPaymentTransactionStateFailed:
				[self failedTransaction:transaction];
				break;
			case SKPaymentTransactionStateRestored:
				[self restoreTransaction:transaction];
			default:
				break;
		}
	}
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	if (transaction.error.code != SKErrorPaymentCancelled)
	{
		//error
		[self finishTransaction:transaction wasSuccessful:NO];
		
		NSString *messageText = [NSString stringWithFormat:@"Unable to purchase Coins. Reason:\"%@.\" Please email support at support@pawsgame.com.", [transaction.error localizedDescription]];;
		NSString *strTitle = [NSString stringWithString:@"Unable To Purchase Coins"];
		UIAlertView *uiav = [[UIAlertView alloc] initWithTitle:strTitle message:messageText delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		
		[uiav show];
		[uiav release];
	}
    
	else 
	{
		//this is fine, the user just cancelled, so don’t notify
		[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	}
    
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
	[self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:transaction.payment.productIdentifier ];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)provideContent:(NSString *)productId
{
    NSInteger numCoinsPurchased = [productId integerValue];
    [self addCoinsForBothCampaigns:numCoinsPurchased];
}

- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
	// remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
	
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
	if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InAppPurchaseTransactionSucceededNotification" object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InAppPurchaseTransactionFailedNotification" object:self userInfo:userInfo];
    }
}

#pragma mark -
#pragma mark Game Center Manager Delegate

- (void) registerForAuthenticationNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver: self
           selector:@selector(authenticationChanged)
               name:GKPlayerAuthenticationDidChangeNotificationName
             object:nil];
}

- (void) authenticateUser
{
	//If Game Center is available, authenticate the logged in (local) Player
	if([GameCenterManager isGameCenterAvailable])
	{
		GameCenterManager *newGCManager = [[[GameCenterManager alloc] init] autorelease];
		[self setGameCenterManager:newGCManager];
		[[self gameCenterManager] setDelegate:self];
		[[self gameCenterManager] authenticateLocalUser];
	}	
}

- (void) authenticationChanged
{

}

- (void) processGameCenterAuth: (NSError*) error
{

}

+ (BOOL) isGameCenterAvailable
{
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

@end
