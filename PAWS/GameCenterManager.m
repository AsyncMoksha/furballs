//
//  GameCenterManager.m
//
//  Created by Joseph Crotchett on 10/26/11.
//  Copyright 2010 N/A. All rights reserved.
//

#import "GameCenterManager.h"
#import <GameKit/GameKit.h>



@implementation GameCenterManager



- (id) init
{
    self = [super init];
    if(self!= NULL)
    {
        earnedAchievementCache= NULL;
        
    }
    return self;
}

- (void) dealloc
{
    self.earnedAchievementCache= NULL;
    [super dealloc];
}




// NOTE:  GameCenter does not guarantee that callback blocks will be execute on the main thread. 
// As such, your application needs to be very careful in how it handles references to view
// controllers.  If a view controller is referenced in a block that executes on a secondary queue,
// that view controller may be released (and dealloc'd) outside the main queue.  This is true
// even if the actual block is scheduled on the main thread.  In concrete terms, this code
// snippet is not safe, even though viewController is dispatching to the main queue:
//
//  [object doSomethingWithCallback:  ^()
//  {
//      dispatch_async(dispatch_get_main_queue(), ^(void)
//      {
//          [viewController doSomething];
//      });
//  }];
//
// UIKit view controllers should only be accessed on the main thread, so the snippet above may
// lead to subtle and hard to trace bugs.  Many solutions to this problem exist.  In this sample,
// I'm bottlenecking everything through  "callDelegateOnMainThread" which calls "callDelegate". 
// Because "callDelegate" is the only method to access the delegate, I can ensure that delegate
// is not visible in any of my block callbacks.

- (void) callDelegate: (SEL) selector withArg: (id) arg error: (NSError*) err
{
    assert([NSThread isMainThread]);
    if([delegate respondsToSelector: selector])
    {
        if(arg != NULL)
        {
            [delegate performSelector: selector withObject: arg withObject: err];
        }
        else
        {
            [delegate performSelector: selector withObject: err];
        }
    }
    else
    {
        NSLog(@"Missed Method");
    }
}


- (void) callDelegateOnMainThread: (SEL) selector withArg: (id) arg error: (NSError*) err
{
    dispatch_async(dispatch_get_main_queue(), ^(void)
				   {
					   [self callDelegate: selector withArg: arg error: err];
				   });
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


- (void) authenticateLocalUser
{
    if([GKLocalPlayer localPlayer].authenticated == NO)
    {
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) 
		 {
			 if(error != nil)
			 {
				 NSLog(@"Error in authenticateLocalUser");
				 return;
			 }
			 
			 [self callDelegateOnMainThread: @selector(processGameCenterAuth:) withArg: NULL error: error];
		 }];
    }
}

- (void) reloadHighScoresForCategory: (NSString*) category
{
    GKLeaderboard* leaderBoard= [[[GKLeaderboard alloc] init] autorelease];
    leaderBoard.category= category;
    leaderBoard.timeScope= GKLeaderboardTimeScopeAllTime;
    leaderBoard.range= NSMakeRange(1, 1);
    
    [leaderBoard loadScoresWithCompletionHandler:  ^(NSArray *scores, NSError *error)
	 {
		 if(error != nil)
		 {
			 NSLog(@"Error in reloadHighScoresForCategory");
			 return;
		 }
		 
		 [self callDelegateOnMainThread: @selector(reloadScoresComplete:error:) withArg: leaderBoard error: error];
	 }];
}

- (void) reportScore: (int64_t) score forCategory: (NSString*) category 
{
    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease]; 
    scoreReporter.value = score;
    [scoreReporter reportScoreWithCompletionHandler: ^(NSError *error) 
     {
		 if(error != nil)
		 {
			 NSLog(@"Error in reportScore");
			 return;
		 }
		 
         [self callDelegateOnMainThread: @selector(scoreReported:) withArg: NULL error: error];
     }];
}

- (void) submitAchievement: (NSString*) identifier percentComplete: (double) percentComplete
{
    //GameCenter check for duplicate achievements when the achievement is submitted, but if you only want to report 
    // new achievements to the user, then you need to check if it's been earned 
    // before you submit.  Otherwise you'll end up with a race condition between loadAchievementsWithCompletionHandler
    // and reportAchievementWithCompletionHandler.  To avoid this, we fetch the current achievement list once,
    // then cache it and keep it updated with any new achievements.
    if(self.earnedAchievementCache == NULL)
    {
        [GKAchievement loadAchievementsWithCompletionHandler: ^(NSArray *scores, NSError *error)
		 {
			 if(error == NULL)
			 {
				 NSMutableDictionary* tempCache= [NSMutableDictionary dictionaryWithCapacity: [scores count]];
				 for (GKAchievement* score in tempCache)
				 {
					 [tempCache setObject: score forKey: score.identifier];
				 }
				 self.earnedAchievementCache= tempCache;
				 [self submitAchievement: identifier percentComplete: percentComplete];
			 }
			 else
			 {
				 //Something broke loading the achievement list.  Error out, and we'll try again the next time achievements submit.
				 [self callDelegateOnMainThread: @selector(achievementSubmitted:error:) withArg: NULL error: error];
			 }
			 
		 }];
    }
    else
    {
		//Search the list for the ID we're using...
        GKAchievement* achievement= [self.earnedAchievementCache objectForKey: identifier];
        if(achievement != NULL)
        {
            if((achievement.percentComplete >= 100.0) || (achievement.percentComplete >= percentComplete))
            {
                //Achievement has already been earned so we're done.
                achievement= NULL;
            }
            achievement.percentComplete= percentComplete;
        }
        else
        {
            achievement= [[[GKAchievement alloc] initWithIdentifier: identifier] autorelease];
            achievement.percentComplete= percentComplete;
            //Add achievement to achievement cache...
            [self.earnedAchievementCache setObject: achievement forKey: achievement.identifier];
        }
        if(achievement!= NULL)
        {
            //Submit the Achievement...
            [achievement reportAchievementWithCompletionHandler: ^(NSError *error)
			 {
                 [self callDelegateOnMainThread: @selector(achievementSubmitted:error:) withArg: achievement error: error];
			 }];
        }
    }
}

- (void) resetAchievements
{
    self.earnedAchievementCache= NULL;
    [GKAchievement resetAchievementsWithCompletionHandler: ^(NSError *error) 
	 {
         [self callDelegateOnMainThread: @selector(achievementResetResult:) withArg: NULL error: error];
	 }];
}

- (void) mapPlayerIDtoPlayer: (NSString*) playerID
{
    [GKPlayer loadPlayersForIdentifiers: [NSArray arrayWithObject: playerID] withCompletionHandler:^(NSArray *playerArray, NSError *error)
	 {
		 GKPlayer* player= NULL;
		 for (GKPlayer* tempPlayer in playerArray)
		 {
			 if([tempPlayer.playerID isEqualToString: playerID])
			 {
				 player= tempPlayer;
				 break;
			 }
		 }
		 [self callDelegateOnMainThread: @selector(mappedPlayerIDToPlayer:error:) withArg: player error: error];
	 }];
    
}



#pragma mark -
#pragma mark Core Data stack

@synthesize earnedAchievementCache;
@synthesize delegate;


@end