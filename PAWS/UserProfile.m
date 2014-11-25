//
//  UserProfile.m
//  PAWS
//
//  Created by Joseph Crotchett on 10/28/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "UserProfile.h"
#import "Card.h"
#import "Item.h"
#import "Level.h"
#import "Achievement.h"


@implementation UserProfile

@dynamic attackDamageLevel;
@dynamic attackDamagePercentage;
@dynamic attackSpeedLevel;
@dynamic attackSpeedPercentage;
@dynamic campaign;
@dynamic coins;
@dynamic hitPointLevel;
@dynamic hitPointPercentage;
@dynamic movementSpeedLevel;
@dynamic movementSpeedPercentage;
@dynamic name;
@dynamic spawnRateLevel;
@dynamic spawnRatePercentage;
@dynamic cards;
@dynamic levels;
@dynamic items;
@dynamic achievements;

#pragma mark -
#pragma mark Achievements

- (Achievement*) getAchievementByID:(NSInteger)aID
{
	NSArray *achievments = [[self achievements] allObjects];
	for(Achievement *achievement in achievments)
	{
		NSInteger aid = [[achievement achievementID] intValue];
		if(aid == aID)
			return achievement;
	}
	
	return nil;
}


@end
